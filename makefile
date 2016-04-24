# Copyright © 2015-2016 Martin Ueding <dev@martin-ueding.de>

.PRECIOUS: %.tex %.pdf build/page/%.pdf

document_tex := Proton_Decay.tex
document_pdf := $(document_tex:%.tex=%.pdf)

figures_tex := $(wildcard Figures/*.tex)
figures_pdf := $(figures_tex:Figures/%.tex=build/%.pdf)

build := _build

figures: $(figures_pdf)

all: $(figures_pdf)
all: $(document_pdf)

test:
	@echo "document: 	$(document_pdf)"
	@echo "figures_tex:	$(figures_tex)"
	@echo "figures_pdf:	$(figures_pdf)"

$(document_pdf): $(figures_pdf)

$(figures_pdf): | $(build)

$(build):
	mkdir -p $(build)/page

$(build)/page/%.tex: Figures/%.tex
	tikzpicture_wrap.py $< $@

$(build)/%.pdf: $(build)/page/%.pdf
	pdfcrop $< $@

%.pdf: %.tex header.sty
	cd $$(dirname $@) \
	    && latexmk -pdflatex='lualatex -halt-on-error $$O $$S' -pdf $$(basename $<)

clean:
	$(RM) *-blx.bib
	$(RM) *.aux *.bbl *.nav *.snm
	$(RM) *.log
	$(RM) *.run.xml
	$(RM) *.out
	$(RM) *.svg
	$(RM) *.pdf
	$(RM) -r build
	latexmk -C
