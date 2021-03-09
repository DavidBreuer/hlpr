.PHONY: install docker tests docs

# install package requirements and development version
install:
	Rscript -e "install.packages('.', repos = NULL, type='source', dependencies = TRUE)" \
	&& Rscript -e "webdriver::install_phantomjs()"

# build docker image
docker:
	docker build -t hlpr . -f Dockerfile \
	&& docker run --rm -it hlpr bash

# run package check and unit tests
tests:
	Rscript -e "devtools::check()" \
	&& (Rscript -e "lintr::lint_package()" || true)

docs:
	Rscript -e "devtools::build_manual()" \
	&& Rscript -e "pkgdown::build_site()" \
	&& Rscript -e "covr::gitlab(file = 'docs/report.html', quiet = FALSE)"
