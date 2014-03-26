PDF := rapport.pdf
TEX := rapport.tex

.PHONY: all $(PDF) clean

all : $(PDF)

$(PDF) : 
	latexmk -pdf -pdflatex="pdflatex -interaction=nonstopmode -synctex=1 -recorder" -use-make $(TEX)

clean :
	latexmk -CA && cd chapters && latexmk -CA



