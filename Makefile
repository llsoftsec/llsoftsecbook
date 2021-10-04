# SPDX-License-Identifier: CC-BY-4.0
# SPDX-FileCopyrightText: © 2021 Arm Limited <kristof.beyls@arm.com>

PANDOCFLAGS = \
	      --table-of-contents \
	      --number-sections \
	      --standalone

.PHONY: all clean pdf html
all: pdf html
pdf: build/book.pdf
html: build/book.html build/default.css build/index.html
clean:
	rm -rf build

build:
	mkdir build

build/default.css: default.css Makefile build
	cp default.css build/default.css

build/book.html: book.md book.bib Makefile build
	pandoc $< -t html --filter pandoc-citeproc \
		-M css=default.css \
		-o $@ $(PANDOCFLAGS)

build/index.html: build/book.html build
	cp build/book.html build/index.html

build/book.tex: book.md book.bib Makefile build
	pandoc $< -t latex --filter pandoc-citeproc -o $@ $(PANDOCFLAGS)

build/book.pdf: build/book.tex Makefile build
	cd build && \
	latexmk -pdf book.tex
