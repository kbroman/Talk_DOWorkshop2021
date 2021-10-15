R_OPTS=--no-save --no-restore --no-init-file --no-site-file # --vanilla, but without --no-environ

STEM = rqtl2

FIGS = Figs/rqtl_lines_code.pdf \
	   Figs/rqtl2_scan.pdf \
	   Figs/intercross.pdf \
	   Figs/lodcurve_insulin_with_effects.pdf

docs/$(STEM).pdf: $(STEM).pdf
	cp $< $@

$(STEM).pdf: $(STEM).tex header.tex $(FIGS)
	xelatex $<

web: $(STEM).pdf
	scp $(STEM).pdf adhara.biostat.wisc.edu:Website/presentations/$(STEM)_pitt2021.pdf

Figs/rqtl_lines_code.pdf: R/colors.R Data/lines_code_by_version.csv R/rqtl_lines_code.R
	cd R;R CMD BATCH rqtl_lines_code.R

Data/lines_code_by_version.csv: Perl/grab_lines_code.pl Data/versions.txt
	cd Perl;grab_lines_code.pl

Figs/rqtl2_scan.pdf: R/rqtl2_figs.R R/colors.R
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

Figs/intercross.pdf: R/intercross.R
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

Figs/lodcurve_insulin_with_effects.pdf: R/lodcurve_insulin.R
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"
