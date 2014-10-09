PREFIX=tc
BENCHDIR=bench/hamming/
FLAGS=-p

.PHONY: all report publish c link clean loc

all:
	$(MAKE) link
	$(MAKE) report

report:
	racket reports/make-report.rkt $(FLAGS) $(BENCHDIR)

publish:
	bash reports/publish.sh

c: graphs/results.casio.dat
	racket compile/compile.rkt -f compile/$(PREFIX)~a.c graphs/results.casio.dat

link:
	raco link casio
	raco link reports
	raco link compile
	raco link casio/simplify

cost:
	$(CC) -O0 cost.c -lm -o cost

clean:
	rm -f cost
	rm -rf graphs/
	rm compile/results.casio.dat
	rm compile/$(PREFIX)*.c
	rm compile/$(PREFIX)*.out

loc:
	find reports/ casio/ -type f -exec cat {} \; | wc -l

doc/tr-14wi.pdf: doc/tr-14wi.tex
	cd doc/ && pdflatex -file-line-error -halt-on-error tr-14wi.tex
	rm doc/tr-14wi.aux doc/tr-14wi.log
