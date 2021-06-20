PANDOCFLAGS = \
	      --table-of-contents \
	      --number-sections

.PHONY: all
all: build/book.pdf

build:
	mkdir build

build/book.pdf: book.md Makefile build
	pandoc $< -o $@ $(PANDOCFLAGS)
