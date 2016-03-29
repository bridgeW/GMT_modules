# Makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
PAPER         =
BUILDDIR      = build

# User-friendly check for sphinx-build
ifeq ($(shell which $(SPHINXBUILD) >/dev/null 2>&1; echo $$?), 1)
$(error The '$(SPHINXBUILD)' command was not found. Make sure you have Sphinx installed, then set the SPHINXBUILD environment variable to point to the full path of the '$(SPHINXBUILD)' executable. Alternatively you can add the directory with the executable to your PATH. If you don't have Sphinx installed, grab it from http://sphinx-doc.org/)
endif

# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source
# the i18n builder cannot share the environment and doctrees with the others
I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source

.PHONY: help clean linkcheck figures github
.PHONY: html latex xelatexpdf

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  html       to make standalone HTML files"
	@echo "  latex      to make LaTeX files"
	@echo "  xelatexpdf to make LaTeX files and run them through xelatex"
	@echo "  linkcheck  to check all external links for integrity"
	@echo "  figures    to update all figures"
	@echo "  github     to push the generated html to github  "

clean:
	rm -rf $(BUILDDIR)/*

figures:
	@echo "Update all figures..."
	make -C scripts

linkcheck:
	$(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) $(BUILDDIR)/linkcheck
	@echo
	@echo "Link check complete; look for any errors in the above output " \
	      "or in $(BUILDDIR)/linkcheck/output.txt."

github: html
	@echo "Push build/html to github/gh-pages"
	ghp-import -b gh-pages -n build/html -m "Update at `date +'%Y-%m-%d %H:%M:%S'`"
	git push github gh-pages:gh-pages

## Builers
html: figures
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

latex: figures
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo
	@echo "Build finished; the LaTeX files are in $(BUILDDIR)/latex."
	@echo "Run \`make' in that directory to run these through (pdf)latex" \
	      "(use \`make latexpdf' here to do that automatically)."

xelatexpdf: figures
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo "Running LaTeX files through pdflatex..."
	cd $(BUILDDIR)/latex; latexmk -xelatex -shell-escape
	@echo "xelatex finished; the PDF files are in $(BUILDDIR)/latex."

release: html xelatexpdf
	cd $(BUILDDIR) && mv html GMT_modules && zip -r ../GMT_modules.zip GMT_modules/
	mv $(BUILDDIR)/latex/GMT_modules.pdf .
	rm -rf $(BUILDDIR)/*
