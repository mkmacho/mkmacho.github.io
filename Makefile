.PHONY: all cv social-card site preview check clean

all: cv site

cv:
	mkdir -p assets cv/build
	latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=cv/build cv/miguel-camacho-horvitz-cv.tex
	cp cv/build/miguel-camacho-horvitz-cv.pdf assets/miguel-camacho-horvitz-cv.pdf

social-card:
	magick -background none assets/social-card.svg assets/social-card.png

site:
	quarto render

preview:
	quarto preview

check: all
	./scripts/check-site.sh

clean:
	latexmk -C -outdir=cv/build cv/miguel-camacho-horvitz-cv.tex
	rm -rf _site .quarto cv/build
