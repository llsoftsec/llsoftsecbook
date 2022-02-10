# SPDX-License-Identifier: CC-BY-4.0
# SPDX-FileCopyrightText: © 2021 Arm Limited <kristof.beyls@arm.com>

version := $(shell git describe --match '0' --dirty="-with-local-changes")
PANDOCFLAGS = \
	      --table-of-contents \
	      --number-sections \
	      --standalone \
	      --filter pandoc-citeproc \
              --metadata=VERSION:$(version)

.PHONY: all clean pdf html
all: pdf html default_pandoc_html_template default_pandoc_latex_template
pdf: build/book.pdf
html: build/book.html build/default.css build/index.html
clean:
	rm -rf build default_pandoc_html_template default_pandoc_latex_template

build:
	mkdir build

build/default.css: theme/html/default.css Makefile build
	cp theme/html/default.css build/default.css

build/book.html: book.md book.bib Makefile build theme/html/pandoc_template.html theme/html/clickable_headers.lua
	pandoc $< -t html \
		--template theme/html/pandoc_template.html \
		--lua-filter theme/html/clickable_headers.lua \
		-M css=default.css \
		-o $@ $(PANDOCFLAGS)

build/index.html: build/book.html build
	cp build/book.html build/index.html

build/book.tex: book.md book.bib Makefile build theme/tex/pandoc_template.tex
	pandoc $< -t latex \
		--template theme/tex/pandoc_template.tex \
		-o $@ $(PANDOCFLAGS)

build/book.pdf: build/book.tex Makefile build
	cd build && \
	latexmk -pdf book.tex

default_pandoc_html_template: Makefile 
	pandoc -D html > $@

default_pandoc_latex_template: Makefile 
	pandoc -D latex > $@
