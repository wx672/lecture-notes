out = 20231152xxx
metadata := $(out).yaml
report_inputs  := $(metadata) $(out).md 
journal_inputs := $(metadata)

journal_pdf: journal_tex
	latexmk $(out)-journal

journal_tex: $(journal_inputs)
	pandoc -t latex --template swfulabjournal -o $(out)-journal.tex $^ 

report_pdf: report_tex
	latexmk $(out)

report_tex: $(report_inputs)
	pandoc --lua-filter=minted.lua -t latex --template swfulabreport -o $(out).tex $^ 

report_html: $(report_inputs)
	pandoc -s -t html5 --lua-filter=minted.lua -o $(out).html $^ 

report_docx: $(report_inputs)
	pandoc -t docx -o $(out).docx $^ 

.PHONY: pdf
pdf: report_pdf journal_pdf

.PHONY: journal
journal: journal_pdf

.PHONY: report
report: report_pdf report_html report_docx

.PHONY: clean Clean
clean:
	rm -rf *.{nav,snm,vrb} _minted*
	latexmk -c || true

Clean: clean
	rm -f $(out)*.tex $(out)*.pdf $(out).html $(out).docx

# See: https://github.com/pandoc/lua-filters/blob/master/minted/Makefile
