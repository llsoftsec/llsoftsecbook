# SPDX-License-Identifier: CC-BY-4.0
# SPDX-FileCopyrightText: © 2021 Arm Limited <kristof.beyls@arm.com>

version := $(shell git describe --match '0' --dirty="-with-local-changes")
# --self-contained ensures images are embedded in the generated HTML.
# --resource-path indicates where pandoc can find external resources, such as
# images.
PANDOCFLAGS = \
	      --table-of-contents \
	      --number-sections \
	      --resource-path=. \
	      --standalone \
	      --embed-resources \
	      --metadata=VERSION:$(version)

COMMONFILTERS = \
          --lua-filter theme/fignos.lua \
          --lua-filter theme/index.lua \
          --citeproc

.PHONY: all clean pdf html
all: pdf html default_pandoc_html_template default_pandoc_latex_template native epub \
     downloads
pdf: build/book.pdf
html: build/book.html build/default.css build/index.html
native: build/book.native
epub: build/book.epub
downloads: build/LLSoftSecBook.pdf build/LLSoftSecBook.html build/LLSoftSecBook.epub

# The source of images are in SVG format.
# The below lines define to convert the SVG source images to PDF images such
# that they can be included in the LaTeX/PDF build.
img/%.pdf: img/%.svg
	rsvg-convert -f pdf -o $@ $<
svgimages := $(wildcard img/*.svg)
pdfimages := $(patsubst %.svg,%.pdf,$(svgimages))
commonfilters := theme/fignos.lua theme/index.lua

clean:
	rm -rf build default_pandoc_html_template default_pandoc_latex_template $(pdfimages)

build:
	mkdir build

build/default.css: theme/html/default.css Makefile build
	cp theme/html/default.css build/default.css

build/book.html: book.md book.bib Makefile build theme/html/pandoc_template.html \
                 theme/html/clickable_headers.lua \
				 theme/html/convert_to_sidenote.lua \
				 theme/html/markup_issue.lua \
				 theme/html/markup_todo.lua \
				 $(commonfilters) \
				 theme/html/add_edit_to_headers.lua \
				 build/default.css $(svgimages)
	pandoc $< -t html \
		--template theme/html/pandoc_template.html \
		--lua-filter theme/html/clickable_headers.lua \
		--lua-filter theme/html/markup_issue.lua \
		--lua-filter theme/html/markup_todo.lua \
		--lua-filter theme/html/convert_to_sidenote.lua \
		--lua-filter theme/html/add_edit_to_headers.lua \
		-M css=build/default.css \
		--default-image-extension=svg \
		-o $@ $(PANDOCFLAGS) $(COMMONFILTERS)

build/book.native: book.md book.bib Makefile build
	pandoc $< -t native -o $@ $(PANDOCFLAGS)

build/book.epub: book.md book.bib Makefile build theme/epub/epub_llsoftsecbook.css
	pandoc $< -t epub3 --default-image-extension=svg \
		--css=theme/epub/epub_llsoftsecbook.css \
		--lua-filter theme/html/markup_issue.lua \
		-o $@ $(PANDOCFLAGS)

build/index.html: build/book.html build
	cp build/book.html build/index.html

build/LLSoftSecBook.pdf: build/book.pdf build
	cp build/book.pdf build/LLSoftSecBook.pdf

build/LLSoftSecBook.html: build/book.html build
	cp build/book.html build/LLSoftSecBook.html

build/LLSoftSecBook.epub: build/book.epub build
	cp build/book.epub build/LLSoftSecBook.epub

build/book.tex: book.md book.bib Makefile build theme/tex/pandoc_template.tex \
				theme/html/markup_issue.lua \
				theme/html/markup_todo.lua \
				$(commonfilters) \
				$(pdfimages)
	pandoc $< -t latex \
		--template theme/tex/pandoc_template.tex \
		--default-image-extension=pdf \
		--lua-filter theme/html/markup_issue.lua \
		--lua-filter theme/html/markup_todo.lua \
		-o $@ $(PANDOCFLAGS) $(COMMONFILTERS)

build/book.pdf: build/book.tex Makefile build
	latexmk -pdf build/book.tex -output-directory=build

default_pandoc_html_template: Makefile
	pandoc -D html > $@

default_pandoc_latex_template: Makefile
	pandoc -D latex > $@
