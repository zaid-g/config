#!/bin/bash

# Delta configuration
git config --global delta.minus-style "syntax #990000"
git config --global delta.plus-style "syntax #004400"
git config --global delta.line-numbers true
git config --global delta.line-numbers-left-format "{nm:>4}┊"
git config --global delta.line-numbers-right-format "{np:>4}│"
git config --global delta.word-diff-regex "\\w+|[^\\w\\s]+"
git config --global delta.minus-emph-style "syntax #ff0000"
git config --global delta.plus-emph-style "syntax #008800"
git config --global delta.whitespace-error-style "reverse purple"
