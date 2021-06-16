PANDOCFLAGS = \
	      --table-of-contents \
	      --number-sections

build/book.pdf: book.md Makefile
	pandoc $< -o $@ $(PANDOCFLAGS)
