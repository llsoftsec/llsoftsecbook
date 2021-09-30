# SPDX-License-Identifier: CC-BY-4.0
# SPDX-FileCopyrightText: © 2021 Arm Limited <kristof.beyls@arm.com>

PANDOCFLAGS = \
	      --table-of-contents \
	      --number-sections \
	      --standalone

.PHONY: all clean
all: build/book.pdf
clean:
	rm -rf build

build:
	mkdir build

build/book.tex: book.md book.bib Makefile build
	pandoc $< -t latex --filter pandoc-citeproc -o $@ $(PANDOCFLAGS)

build/book.pdf: build/book.tex Makefile build
	cd build && \
	latexmk -pdf book.tex
