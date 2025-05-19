out = 20251152xxx
metadata := $(out).yaml
report_inputs := $(metadata) $(out).md 
filter_dir = /usr/local/share/pandoc/filters
template_dir = /usr/local/share/pandoc/templates

report_pdf: report_tex
	latexmk $(out)

report_tex: $(report_inputs)
	pandoc --lua-filter=$(filter_dir)/minted.lua -t latex --template $(template_dir)/swfucoursework -o $(out).tex $^ 

report_html: $(report_inputs)
	pandoc -s -t html5 --lua-filter=$(filter_dir)/minted.lua -o $(out).html $^ 

.PHONY: pdf
pdf: report_pdf

.PHONY: report
report: report_pdf report_html

.PHONY: clean Clean
clean:
	rm -rf *.{nav,snm,vrb} _minted*
	latexmk -c || true

Clean: clean
	rm -f $(out)*.tex $(out)*.pdf $(out).html

# See: https://github.com/pandoc/lua-filters/blob/master/minted/Makefile
