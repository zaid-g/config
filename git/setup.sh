#!/bin/bash

# Delta configuration
git config --global delta.minus-style "syntax #990000"
git config --global delta.plus-style "syntax #004400"
git config --global delta.line-numbers true
git config --global delta.line-numbers-left-format "{nm:>4}┊"
git config --global delta.line-numbers-right-format "{np:>4}│"
