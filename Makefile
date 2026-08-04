# Repo chores. `make test` runs everything under tests/.
# Test suites auto-discovered by filename: tests/zsh/test_*.zsh — add a file, it runs.

.PHONY: test test-zsh

test: test-zsh

test-zsh:
	@for test_file in tests/zsh/test_*.zsh; do \
		echo "== $$test_file =="; \
		zsh "$$test_file" || exit 1; \
	done
