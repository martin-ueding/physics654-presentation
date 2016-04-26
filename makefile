# Copyright © 2015-2016 Martin Ueding <dev@martin-ueding.de>

.PRECIOUS: %.tex %.pdf build/page/%.pdf

build := _build

document_tex := Proton_Decay.tex
document_pdf := $(document_tex:%.tex=%.pdf)

figures_tex := $(wildcard Figures/*.tex)
figures_pdf := $(figures_tex:Figures/%.tex=$(build)/%.pdf)

all: $(figures_pdf)
all: $(document_pdf)

figures: $(figures_pdf)


test:
	@echo "document: 	$(document_pdf)"
	@echo "figures_tex:	$(figures_tex)"
	@echo "figures_pdf:	$(figures_pdf)"

$(document_pdf): $(figures_pdf)

$(figures_pdf): | $(build)

$(build):
	mkdir -p $(build)/page

$(build)/page/%.tex: Figures/%.tex
	./tikzpicture_wrap.py $< $@

$(build)/%.pdf: $(build)/page/%.pdf
	pdfcrop $< $@

$(build)/page/%.pdf: $(build)/page/%.tex header.sty
	cd $$(dirname $@) \
	    && latexmk -pdflatex='lualatex -halt-on-error $$O $$S' -pdf $$(basename $<)

%.pdf: %.tex header.sty
	latexmk -pdflatex='pdflatex -halt-on-error $$O $$S' -pdf $<

clean:
	$(RM) *-blx.bib
	$(RM) *.aux *.bbl *.nav *.snm
	$(RM) *.log
	$(RM) *.run.xml
	$(RM) *.out
	$(RM) *.svg
	$(RM) *.pdf
	$(RM) -r $(build)
	latexmk -C
