out = 20231152xxx
pandoc_inputs := $(out).md $(out).yaml

pdf: tex
	latexmk $(out)

tex: $(pandoc_inputs)
	pandoc --lua-filter=minted.lua -t latex --template swfulabreport -o $(out).tex $^ 

html: $(pandoc_inputs)
	pandoc -s -t html5 --lua-filter=minted.lua -o $(out).html $^ 

docx: $(pandoc_inputs)
	pandoc -t docx -o $(out).docx $^ 

.PHONY: all
all: pdf html docx

.PHONY: clean Clean
clean:
	rm -rf *.{nav,snm,vrb} _minted-*
	latexmk -c || true

Clean: clean
	rm -f $(out).tex $(out).pdf $(out).html $(out).docx

# See: https://github.com/pandoc/lua-filters/blob/master/minted/Makefile
