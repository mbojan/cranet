default:

%.md: %.Rmd
	Rscript -e 'rmarkdown::render("$<", output_file="$@")'
	
.PHONY: default
