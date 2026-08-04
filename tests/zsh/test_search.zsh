#!/usr/bin/env zsh
# Test suite for the [find search grep] section of zsh/zshrc.
#
# Hermetic: builds a sandbox HOME (with its own gitignore fixture) and a fixture
# project dir, extracts the section from zshrc, and asserts the section's spec:
#   - scope: all files under . minus gitignore patterns; hidden files included;
#     repos' own .gitignore files irrelevant
#   - all matching is case-insensitive
#   - find/fd and grep/rg engine pairs return the same results
#   - content searches skip files over 50MB and print path:line:content
#   - no WARN_CREATE_GLOBAL violations anywhere
# Never touches real files. FIND1 is not covered (odd one out by design).
#
# Usage: zsh tests/zsh/test_search.zsh   (or: make test)

TEST_SCRIPT_PATH="${0:A}"
ZSHRC_PATH="${TEST_SCRIPT_PATH:h:h:h}/zsh/zshrc"
[[ -f "$ZSHRC_PATH" ]] || { echo "cannot find zshrc at $ZSHRC_PATH" >&2; exit 1 }

typeset -g tests_passed=0 tests_failed=0

function ASSERT_EQUALS() { # <description> <expected> <actual>
    if [[ "$2" == "$3" ]]; then
        ((tests_passed++))
    else
        ((tests_failed++))
        echo "FAIL: $1"
        echo "    expected: $2"
        echo "    actual:   $3"
    fi
}

function ASSERT_CONTAINS() { # <description> <haystack> <needle>
    if [[ "$2" == *"$3"* ]]; then
        ((tests_passed++))
    else
        ((tests_failed++))
        echo "FAIL: $1"
        echo "    expected to contain: $3"
        echo "    actual: $2"
    fi
}

function ASSERT_NOT_CONTAINS() { # <description> <haystack> <needle>
    if [[ "$2" != *"$3"* ]]; then
        ((tests_passed++))
    else
        ((tests_failed++))
        echo "FAIL: $1"
        echo "    expected NOT to contain: $3"
    fi
}

function ASSERT_EMPTY() { # <description> <value>
    if [[ -z "$2" ]]; then
        ((tests_passed++))
    else
        ((tests_failed++))
        echo "FAIL: $1"
        echo "    expected empty, got: $2"
    fi
}

# --- test: whole zshrc parses ---
zsh -n "$ZSHRC_PATH"
ASSERT_EQUALS "zshrc passes zsh -n syntax check" 0 $?

# --- sandbox setup ---
SANDBOX=$(mktemp -d)
trap 'rm -rf "$SANDBOX"' EXIT INT TERM

# fake HOME whose gitignore exercises parsing: a comment, a blank line,
# a trailing-slash dir pattern, and a bare pattern
FAKE_HOME="$SANDBOX/home"
mkdir -p "$FAKE_HOME/doc/config/config/git"
cat > "$FAKE_HOME/doc/config/config/git/gitignore" <<'EOF'
# a comment that must be skipped

node_modules/
.git
EOF

# fixture project
PROJECT_DIR="$SANDBOX/project"
mkdir -p "$PROJECT_DIR"/{node_modules,sub,brain/junk,projA/brain,projB/brain}
print "alpha content"                  > "$PROJECT_DIR/visible.txt"
print "SeNtInEl_MiXeD case content"    > "$PROJECT_DIR/MixedCase.TXT"
print "hidden_sentinel content"        > "$PROJECT_DIR/.hidden.txt"
print "python_sentinel = 1"            > "$PROJECT_DIR/script.py"
print "noext_sentinel"                 > "$PROJECT_DIR/noextension"
print "excluded_sentinel"              > "$PROJECT_DIR/node_modules/excluded.txt"
print "alpha nested"                   > "$PROJECT_DIR/sub/nested.txt"
print "brainword_one and brainword_two" > "$PROJECT_DIR/brain/notes.txt"
print "brainword_one only"             > "$PROJECT_DIR/brain/junk/junk.txt"
print "hidden_brainword here"          > "$PROJECT_DIR/brain/.hidden_note.txt"
print "2026_01_02-10_00_00"            > "$PROJECT_DIR/projA/brain/.last_opened"
print "2026_01_01-09_00_00"            > "$PROJECT_DIR/projB/brain/.last_opened"
print "space_sentinel content"         > "$PROJECT_DIR/with space.txt"
print -- "-dash_sentinel line"         > "$PROJECT_DIR/dash.txt"
printf 'first line\nsecond_line_sentinel\n' > "$PROJECT_DIR/multi.txt"
print "multi_ext_sentinel here"        > "$PROJECT_DIR/ext1.py"
print "multi_ext_sentinel too"         > "$PROJECT_DIR/ext2.txt"
print "multi_ext_sentinel extensionless" >> "$PROJECT_DIR/noextension"
{ dd if=/dev/zero bs=1048576 count=51 2>/dev/null; print "big_sentinel at the end" } > "$PROJECT_DIR/big.txt"

export HOME="$FAKE_HOME"
setopt WARN_CREATE_GLOBAL

# source the ENTIRE zshrc (not an extracted section): tests the functions as they
# exist in a fully loaded shell, including any cross-section interference.
# Load-time stderr goes to its own log; assertion failures below would surface it.
ZSHRC_LOAD_LOG="$SANDBOX/zshrc_load.log"
source "$ZSHRC_PATH" 2> "$ZSHRC_LOAD_LOG"
typeset -f _FIND > /dev/null
ASSERT_EQUALS "zshrc sources fully and defines the search functions" 0 $?
ASSERT_EQUALS "zshrc load emits no WARN_CREATE_GLOBAL violations" 0 \
    "$(grep -c 'created globally' "$ZSHRC_LOAD_LOG")"

# warn log for the test-driven calls below (kept separate from load-time stderr)
WARN_LOG="$SANDBOX/warn.log"
touch "$WARN_LOG"
cd "$PROJECT_DIR"

# helpers: shorthand output minus the leading blank line every shorthand emits
function TEST_GREP()   { GREP "$@"   | sed 1d }
function TEST_GREPT()  { GREPT "$@"  | sed 1d }
function TEST_RGT()    { RGT "$@"    | sed 1d }
function TEST_RG()     { RG "$@"     | sed 1d }
function TEST_RGB()    { RGB "$@"    | sed 1d }
function TEST_RGANY()  { RGANY "$@"  | sed 1d }
function TEST_RGBANY() { RGBANY "$@" | sed 1d }
function TEST_RGALL()  { RGALL "$@"  | sed 1d }
function TEST_RGBALL() { RGBALL "$@" | sed 1d }

# --- GET_GITIGNORE_PATTERNS ---
patterns_output=$(GET_GITIGNORE_PATTERNS 2>> "$WARN_LOG")
ASSERT_EQUALS "gitignore parsing skips comments/blanks and strips trailing slash" \
    $'node_modules\n.git' "$patterns_output"

missing_gitignore_status=$( (export HOME="$SANDBOX/nonexistent_home"; GET_GITIGNORE_PATTERNS >/dev/null 2>&1); echo $? )
ASSERT_EQUALS "missing gitignore file returns nonzero" 1 "$missing_gitignore_status"

# --- CONSTRUCT_* exclude args ---
constructed_exclude_args=()
CONSTRUCT_FIND_EXCLUDE_ARGS_FROM_GITIGNORE_PATTERNS 2>> "$WARN_LOG"
ASSERT_EQUALS "find exclude args: 4 args per pattern" 8 ${#constructed_exclude_args[@]}
ASSERT_EQUALS "find exclude args form" "-path */node_modules -prune -o" "${constructed_exclude_args[1,4]}"

constructed_exclude_args=()
CONSTRUCT_FD_EXCLUDE_ARGS_FROM_GITIGNORE_PATTERNS 2>> "$WARN_LOG"
ASSERT_EQUALS "fd exclude args: 2 args per pattern" 4 ${#constructed_exclude_args[@]}
ASSERT_EQUALS "fd exclude args form" "--exclude node_modules" "${constructed_exclude_args[1,2]}"

constructed_exclude_args=()
CONSTRUCT_RG_EXCLUDE_ARGS_FROM_GITIGNORE_PATTERNS 2>> "$WARN_LOG"
ASSERT_EQUALS "rg exclude args: 2 args per pattern" 4 ${#constructed_exclude_args[@]}
ASSERT_EQUALS "rg exclude args form" "--glob !**/node_modules/**" "${constructed_exclude_args[1,2]}"

function _CONSTRUCTOR_FAILURE_PROBE() {
    local -a constructed_exclude_args
    HOME="$SANDBOX/nonexistent_home" CONSTRUCT_FIND_EXCLUDE_ARGS_FROM_GITIGNORE_PATTERNS 2>/dev/null
}
_CONSTRUCTOR_FAILURE_PROBE
ASSERT_EQUALS "constructors propagate missing-gitignore failure" 1 $?

# --- enumerators: _FIND / _FD ---
find_output=$(_FIND 2>> "$WARN_LOG")
ASSERT_CONTAINS "_FIND lists regular files" "$find_output" "./visible.txt"
ASSERT_CONTAINS "_FIND includes hidden files" "$find_output" "./.hidden.txt"
ASSERT_CONTAINS "_FIND lists big files (no size limit on path finding)" "$find_output" "./big.txt"
ASSERT_NOT_CONTAINS "_FIND excludes gitignored dirs" "$find_output" "excluded.txt"

parity_diff=$(diff <(_FIND 2>> "$WARN_LOG" | sort) <(_FD 2>> "$WARN_LOG" | sort))
ASSERT_EQUALS "engine parity: _FIND and _FD return identical file sets" "" "$parity_diff"

# --- stdin filters ---
ASSERT_EQUALS "extension filter matches case-insensitively" $'a.txt\nc.TXT' \
    "$(print -l a.txt b.py c.TXT | FILTER_FILE_PATHS_FROM_STDIN_BY_EXTENSIONS txt)"
ASSERT_EQUALS "extension filter accepts multiple extensions" $'a.txt\nb.py\nc.TXT' \
    "$(print -l a.txt b.py c.TXT | FILTER_FILE_PATHS_FROM_STDIN_BY_EXTENSIONS txt py)"
ASSERT_EQUALS "extension filter with no args passes everything through" $'a.txt\nb.py\nc.TXT' \
    "$(print -l a.txt b.py c.TXT | FILTER_FILE_PATHS_FROM_STDIN_BY_EXTENSIONS)"
ASSERT_EQUALS "pattern filter matches case-insensitively" "b.py" \
    "$(print -l a.txt b.py | FILTER_FILE_PATHS_FROM_STDIN_BY_PATTERN PY)"
ASSERT_EQUALS "pattern filter with empty pattern passes everything through" $'a.txt\nb.py' \
    "$(print -l a.txt b.py | FILTER_FILE_PATHS_FROM_STDIN_BY_PATTERN "")"
ASSERT_EMPTY "extension filter requires a dot and end-anchor (no substring matches)" \
    "$(print -l a.txt2 atxt | FILTER_FILE_PATHS_FROM_STDIN_BY_EXTENSIONS txt)"
ASSERT_EQUALS "pattern filter supports extended regex (alternation, anchors)" $'a.txt\nb.py' \
    "$(print -l a.txt b.py c.log | FILTER_FILE_PATHS_FROM_STDIN_BY_PATTERN "txt$|py$")"
ASSERT_EMPTY "pattern filter outputs nothing when nothing matches" \
    "$(print -l a.txt | FILTER_FILE_PATHS_FROM_STDIN_BY_PATTERN zzz_no_match)"

# --- path-finding shorthands ---
findt_txt=$(FINDT txt 2>> "$WARN_LOG")
ASSERT_EQUALS "shorthands lead with a blank line" "" "$(print -r -- "$findt_txt" | sed -n 1p)"
ASSERT_CONTAINS "FINDT matches lowercase extension" "$findt_txt" "./visible.txt"
ASSERT_CONTAINS "FINDT matches uppercase extension (case-insensitive)" "$findt_txt" "./MixedCase.TXT"
ASSERT_CONTAINS "FINDT matches hidden dotfiles" "$findt_txt" "./.hidden.txt"
ASSERT_NOT_CONTAINS "FINDT txt excludes .py files" "$findt_txt" "script.py"
ASSERT_NOT_CONTAINS "FINDT txt excludes extensionless files" "$findt_txt" "noextension"
ASSERT_EQUALS "FINDT with no args lists all files sorted" "$(_FIND 2>> "$WARN_LOG" | sort)" \
    "$(FINDT 2>> "$WARN_LOG" | sed 1d)"

ASSERT_EQUALS "FIND path pattern is case-insensitive" "./MixedCase.TXT" \
    "$(FIND mixedcase 2>> "$WARN_LOG" | sed 1d)"
ASSERT_EQUALS "FIND with no pattern lists all files sorted" "$(_FIND 2>> "$WARN_LOG" | sort)" \
    "$(FIND 2>> "$WARN_LOG" | sed 1d)"

ASSERT_EQUALS "FDT returns same results as FINDT" "$findt_txt" "$(FDT txt 2>> "$WARN_LOG")"
ASSERT_EQUALS "FD returns same results as FIND" "$(FIND sub 2>> "$WARN_LOG")" "$(FD sub 2>> "$WARN_LOG")"

# --- content searchers: grep engine ---
grep_alpha=$(TEST_GREP alpha 2>> "$WARN_LOG")
ASSERT_CONTAINS "GREP prints path:line:content" "$grep_alpha" "./visible.txt:1:alpha content"
ASSERT_CONTAINS "GREP is case-insensitive" "$(TEST_GREP ALPHA 2>> "$WARN_LOG")" "./visible.txt:1:alpha content"
ASSERT_CONTAINS "GREP searches hidden files" "$(TEST_GREP hidden_sentinel 2>> "$WARN_LOG")" "./.hidden.txt:1:"
ASSERT_EQUALS "GREPT extension restriction" "./script.py:1:python_sentinel = 1" \
    "$(TEST_GREPT py python_sentinel 2>> "$WARN_LOG")"
ASSERT_EMPTY "GREPT wrong extension finds nothing" "$(TEST_GREPT txt python_sentinel 2>> "$WARN_LOG")"
ASSERT_EMPTY "GREP skips files over 50MB" "$(TEST_GREP big_sentinel 2>> "$WARN_LOG")"
ASSERT_EMPTY "GREP never searches excluded dirs" "$(TEST_GREP excluded_sentinel 2>> "$WARN_LOG")"

grep_multi_ext=$(TEST_GREPT py txt multi_ext_sentinel 2>> "$WARN_LOG" | sort)
ASSERT_CONTAINS "GREPT multiple extensions: matches .py" "$grep_multi_ext" "./ext1.py:1:"
ASSERT_CONTAINS "GREPT multiple extensions: matches .txt" "$grep_multi_ext" "./ext2.txt:1:"
ASSERT_NOT_CONTAINS "GREPT multiple extensions: excludes other files" "$grep_multi_ext" "noextension"
ASSERT_CONTAINS "GREPT lowercase ext matches uppercase .TXT files" \
    "$(TEST_GREPT txt sentinel_mixed 2>> "$WARN_LOG")" "./MixedCase.TXT:1:"
ASSERT_EQUALS "GREP handles filenames with spaces" "./with space.txt:1:space_sentinel content" \
    "$(TEST_GREP space_sentinel 2>> "$WARN_LOG")"
ASSERT_EQUALS "GREP handles patterns starting with a dash" "./dash.txt:1:-dash_sentinel line" \
    "$(TEST_GREP "-dash_sentinel" 2>> "$WARN_LOG")"
ASSERT_EQUALS "GREP reports correct line numbers" "./multi.txt:2:second_line_sentinel" \
    "$(TEST_GREP second_line_sentinel 2>> "$WARN_LOG")"

# --- content searchers: rg engine + parity ---
grep_normalized=$(TEST_GREP alpha 2>> "$WARN_LOG" | sort)
rg_normalized=$(TEST_RG alpha 2>> "$WARN_LOG" | sort)
ASSERT_EQUALS "engine parity: TEST_GREP and TEST_RG find the same matches" "$grep_normalized" "$rg_normalized"
ASSERT_CONTAINS "RGT is case-insensitive with extension filter" \
    "$(TEST_RGT py PYTHON_SENTINEL 2>> "$WARN_LOG")" "script.py:1:python_sentinel = 1"
ASSERT_EMPTY "RG skips files over 50MB" "$(TEST_RG big_sentinel 2>> "$WARN_LOG")"
ASSERT_EMPTY "RG never searches excluded dirs" "$(TEST_RG excluded_sentinel 2>> "$WARN_LOG")"
ASSERT_CONTAINS "RGT lowercase ext matches uppercase .TXT files (glob-case-insensitive)" \
    "$(TEST_RGT txt sentinel_mixed 2>> "$WARN_LOG")" "MixedCase.TXT:1:"
ASSERT_EQUALS "RG handles filenames with spaces" "./with space.txt:1:space_sentinel content" \
    "$(TEST_RG space_sentinel 2>> "$WARN_LOG")"
ASSERT_EQUALS "RG handles patterns starting with a dash" "./dash.txt:1:-dash_sentinel line" \
    "$(TEST_RG "-dash_sentinel" 2>> "$WARN_LOG")"
ASSERT_EQUALS "engine parity on multi-extension search" "$grep_multi_ext" \
    "$(TEST_RGT py txt multi_ext_sentinel 2>> "$WARN_LOG" | sort)"
ASSERT_EQUALS "engine parity on hidden-file content" \
    "$(TEST_GREP hidden_sentinel 2>> "$WARN_LOG" | sort)" \
    "$(TEST_RG hidden_sentinel 2>> "$WARN_LOG" | sort)"

# --- stdin content stage ---
ASSERT_EQUALS "stdin content stage greps listed files" "./visible.txt:1:alpha content" \
    "$(print ./visible.txt | GREP_CONTENTS_OF_FILE_PATHS_FROM_STDIN alpha 2>> "$WARN_LOG")"
ASSERT_EMPTY "stdin content stage silently skips nonexistent paths" \
    "$(print ./does_not_exist.txt | GREP_CONTENTS_OF_FILE_PATHS_FROM_STDIN alpha 2>> "$WARN_LOG")"
ASSERT_EQUALS "stdin content stage processes multiple paths in order" \
    $'./visible.txt:1:alpha content\n./sub/nested.txt:1:alpha nested' \
    "$(print -l ./visible.txt ./sub/nested.txt | GREP_CONTENTS_OF_FILE_PATHS_FROM_STDIN alpha 2>> "$WARN_LOG")"
ASSERT_EMPTY "stdin content stage skips >50MB files directly" \
    "$(print ./big.txt | GREP_CONTENTS_OF_FILE_PATHS_FROM_STDIN big_sentinel 2>> "$WARN_LOG")"

# --- shorthand wrappers ---
ASSERT_EQUALS "GREP shorthand: patterns only, leading blank line" \
    $'\n./script.py:1:python_sentinel = 1' "$(GREP python_sentinel 2>> "$WARN_LOG")"
ASSERT_EQUALS "RG shorthand: patterns only, leading blank line" \
    $'\n./script.py:1:python_sentinel = 1' "$(RG python_sentinel 2>> "$WARN_LOG")"
ASSERT_EQUALS "GREPT shorthand: exts then pattern" \
    $'\n./script.py:1:python_sentinel = 1' "$(GREPT py python_sentinel 2>> "$WARN_LOG")"
ASSERT_EQUALS "RGT shorthand: exts then pattern" \
    $'\n./script.py:1:python_sentinel = 1' "$(RGT py python_sentinel 2>> "$WARN_LOG")"
ASSERT_EQUALS "RG multi-pattern is an OR" \
    $'./script.py:1:python_sentinel = 1\n./sub/nested.txt:1:alpha nested\n./visible.txt:1:alpha content' \
    "$(TEST_RG alpha python_sentinel 2>> "$WARN_LOG" | sort)"
ASSERT_EQUALS "GREP multi-pattern is an OR (repeated -e, matches RG)" \
    "$(TEST_RG alpha python_sentinel 2>> "$WARN_LOG" | sort)" \
    "$(TEST_GREP alpha python_sentinel 2>> "$WARN_LOG" | sort)"

# --- the RG[B][ANY|ALL] grid ---
ASSERT_EQUALS "lines core with empty scope = _RG" "$(TEST_RG alpha 2>> "$WARN_LOG" | sort)" \
    "$(_RG --output lines --match any -- alpha 2>> "$WARN_LOG" | sort)"
ASSERT_EQUALS "RGB shows matching lines from brain files only" \
    "./brain/notes.txt:1:brainword_one and brainword_two" \
    "$(TEST_RGB brainword_two 2>> "$WARN_LOG")"
ASSERT_EMPTY "RGB never shows non-brain matches" \
    "$(TEST_RGB alpha 2>> "$WARN_LOG")"
ASSERT_EQUALS "RGB takes patterns only (multi-pattern OR)" \
    $'./brain/.hidden_note.txt:1:hidden_brainword here\n./brain/notes.txt:1:brainword_one and brainword_two' \
    "$(TEST_RGB brainword_two hidden_brainword 2>> "$WARN_LOG" | sort)"
ASSERT_EQUALS "brain+ext lines goes through the door" \
    "./brain/notes.txt:1:brainword_one and brainword_two" \
    "$(_RG --output lines --match any --glob "**/brain/**" --ext txt -- brainword_two 2>> "$WARN_LOG")"
ASSERT_EQUALS "RGANY lists file paths mentioning any term, everywhere, sorted (R3)" \
    $'./sub/nested.txt\n./visible.txt' \
    "$(RGANY alpha zzz_no_such_term 2>> "$WARN_LOG" | sed 1d)"

# --- brain searches ---
ASSERT_EQUALS "RGBANY single term finds the brain file" "./brain/notes.txt" \
    "$(TEST_RGBANY brainword_two 2>> "$WARN_LOG")"
ASSERT_EQUALS "RGBANY is case-insensitive" "./brain/notes.txt" \
    "$(TEST_RGBANY BRAINWORD_TWO 2>> "$WARN_LOG")"
ASSERT_EQUALS "RGBANY finds hidden brain files" "./brain/.hidden_note.txt" \
    "$(TEST_RGBANY hidden_brainword 2>> "$WARN_LOG")"
ASSERT_EMPTY "RGBANY only searches under brain/ paths" \
    "$(TEST_RGBANY alpha 2>> "$WARN_LOG")"
ASSERT_EQUALS "RGBANY multiple terms is an OR" $'./brain/.hidden_note.txt\n./brain/notes.txt' \
    "$(TEST_RGBANY brainword_two hidden_brainword 2>> "$WARN_LOG" | sort)"

ASSERT_EQUALS "RGBALL requires all terms" "./brain/notes.txt" \
    "$(TEST_RGBALL brainword_one brainword_two 2>> "$WARN_LOG")"
ASSERT_EMPTY "RGBALL empty when any term is missing" \
    "$(TEST_RGBALL brainword_one zzz_no_such_term 2>> "$WARN_LOG")"
ASSERT_EQUALS "RGBALL with a single term matches all files containing it" \
    $'./brain/junk/junk.txt\n./brain/notes.txt' \
    "$(TEST_RGBALL brainword_one 2>> "$WARN_LOG" | sort)"
ASSERT_EQUALS "RGBALL chains three terms" "./brain/notes.txt" \
    "$(TEST_RGBALL brainword_one and brainword_two 2>> "$WARN_LOG")"
ASSERT_EQUALS "RGBALL is order-independent" "./brain/notes.txt" \
    "$(TEST_RGBALL brainword_two brainword_one 2>> "$WARN_LOG")"
ASSERT_EQUALS "ALL keeps hidden files through the narrowing passes" "./brain/.hidden_note.txt" \
    "$(TEST_RGBALL hidden_brainword here 2>> "$WARN_LOG")"

# --- non-brain ANY/ALL (RGALL) ---
ASSERT_EQUALS "scoped core restricts to an arbitrary glob" "./sub/nested.txt" \
    "$(_RG --output file_paths --match any --glob "**/sub/**" -- alpha 2>> "$WARN_LOG")"
ASSERT_EQUALS "scoped core with empty scope searches everywhere" \
    $'./sub/nested.txt\n./visible.txt' \
    "$(_RG --output file_paths --match any -- alpha 2>> "$WARN_LOG" | sort)"
ASSERT_EQUALS "all-mode keeps files whose contents match all patterns" "./visible.txt" \
    "$(_RG --output file_paths --match all -- alpha content 2>> "$WARN_LOG")"
ASSERT_EQUALS "all-mode respects the scope glob" "./brain/notes.txt" \
    "$(_RG --output file_paths --match all --glob "**/brain/**" -- brainword_one brainword_two 2>> "$WARN_LOG")"
ASSERT_EQUALS "all-mode supports --ext restriction" "./ext2.txt" \
    "$(_RG --output file_paths --match all --ext py --ext txt -- multi_ext_sentinel too 2>> "$WARN_LOG")"
ASSERT_EMPTY "all-mode --ext excludes files with other extensions" \
    "$(_RG --output file_paths --match all --ext py --ext txt -- multi_ext_sentinel extensionless 2>> "$WARN_LOG")"
ASSERT_EQUALS "-- protects patterns that start with a dash in all mode" "./dash.txt" \
    "$(_RG --output file_paths --match all -- "-dash_sentinel" line 2>> "$WARN_LOG")"
ASSERT_EQUALS "all dimensions at once: lines output, all match, multiple exts" \
    "./ext2.txt:1:multi_ext_sentinel too" \
    "$(_RG --output lines --match all --ext py --ext txt -- multi_ext_sentinel too 2>> "$WARN_LOG")"
ASSERT_EQUALS "all dimensions at once: adding a scope glob" \
    "./brain/notes.txt:1:brainword_one and brainword_two" \
    "$(_RG --output lines --match all --glob "**/brain/**" --ext txt -- brainword_one brainword_two 2>> "$WARN_LOG")"
ASSERT_EQUALS "lines-all shows matching lines within files containing every pattern" \
    "./sub/nested.txt:1:alpha nested" \
    "$(_RG --output lines --match all -- alpha nested 2>> "$WARN_LOG")"
ASSERT_EQUALS "lines-all is case-insensitive across narrowing passes" "./sub/nested.txt:1:alpha nested" \
    "$(_RG --output lines --match all -- ALPHA NESTED 2>> "$WARN_LOG")"
ASSERT_EQUALS "lines-all shows each pattern's lines even when on different lines of the file" \
    $'./multi.txt:1:first line\n./multi.txt:2:second_line_sentinel' \
    "$(_RG --output lines --match all -- first second_line_sentinel 2>> "$WARN_LOG")"
ASSERT_EMPTY "lines-all empty when no single file contains all patterns" \
    "$(_RG --output lines --match all -- alpha python_sentinel 2>> "$WARN_LOG")"
ASSERT_EQUALS "RG_FILE_PATHS ANY matches across all searchable files" \
    $'./sub/nested.txt\n./visible.txt' \
    "$(TEST_RGANY alpha 2>> "$WARN_LOG" | sort)"
ASSERT_EQUALS "RGALL requires all terms (non-brain files)" "./visible.txt" \
    "$(TEST_RGALL alpha content 2>> "$WARN_LOG")"
ASSERT_EQUALS "RGALL is case-insensitive" "./visible.txt" \
    "$(TEST_RGALL ALPHA CONTENT 2>> "$WARN_LOG")"
ASSERT_EMPTY "RGALL empty when any term is missing" \
    "$(TEST_RGALL alpha zzz_no_such_term 2>> "$WARN_LOG")"
ASSERT_EQUALS "RGALL searches brain files too (superset of RGBALL scope)" "./brain/notes.txt" \
    "$(TEST_RGALL brainword_one brainword_two 2>> "$WARN_LOG")"
ASSERT_EMPTY "RGALL never matches in excluded dirs" \
    "$(TEST_RGALL excluded_sentinel 2>> "$WARN_LOG")"
ASSERT_EQUALS "RGALL chains three terms" "./brain/notes.txt" \
    "$(TEST_RGALL brainword_one and brainword_two 2>> "$WARN_LOG")"

# --- brain parents by last opened ---
fdbp_output=$(FD_BRAIN_PARENTS_SORT_BY_LAST_OPENED 2>> "$WARN_LOG")
ASSERT_EQUALS "brain parents: exactly the two projects with .last_opened" 2 \
    "$(print -r -- "$fdbp_output" | grep -c proj)"
ASSERT_CONTAINS "brain parents sorted by timestamp: older first" \
    "$(print -r -- "$fdbp_output" | sed -n 1p)" "projB"
ASSERT_CONTAINS "brain parents sorted by timestamp: newer second" \
    "$(print -r -- "$fdbp_output" | sed -n 2p)" "projA"
ASSERT_EQUALS "FDBP shorthand = leading blank line + FD_BRAIN_PARENTS_SORT_BY_LAST_OPENED" \
    $'\n'"$fdbp_output" "$(FDBP 2>> "$WARN_LOG")"

# --- every user-called shorthand leads with a blank line ---
for shorthand_invocation in "FINDT txt" "FIND visible" "FDT txt" "FD visible" "FDBP" \
    "GREP alpha" "GREPT txt alpha" "RG alpha" "RGT txt alpha" "RGB brainword_one" "RGANY alpha" "RGBANY brainword_one" \
    "RGBALL brainword_one" "RGALL alpha"; do
    first_output_line=$(eval "$shorthand_invocation" 2>> "$WARN_LOG" | sed -n 1p)
    ASSERT_EQUALS "shorthand leads with blank line: $shorthand_invocation" "" "$first_output_line"
done

# --- WARN_CREATE_GLOBAL cleanliness across everything above ---
ASSERT_EQUALS "no WARN_CREATE_GLOBAL violations" 0 "$(grep -c 'created globally' "$WARN_LOG")"

# --- summary ---
echo
echo "passed: $tests_passed, failed: $tests_failed"
if [[ $tests_failed -eq 0 ]]; then
    echo "ALL TESTS PASSED"
    exit 0
else
    echo "TESTS FAILED"
    exit 1
fi
