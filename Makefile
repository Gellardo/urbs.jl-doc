all:
	echo bla
images: data/*.csv
	touch images/test
	echo images
presentation.pdf: presentation.md images
	pandoc -t beamer --slide-level 2 -o presentation.pdf presentation.md
presentation: presentation.pdf
report: images
	echo report
