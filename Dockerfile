FROM r-base:3.6.1
LABEL maintainer="David Breuer <info@info.com>"

ARG DEPS="\
    g++ \
    make \
    liblzma-dev \
    zlib1g-dev \
    pandoc \
    texinfo \
    texlive \
    texlive-fonts-extra \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev"

WORKDIR /app
RUN apt-get update
RUN apt-get install -y --no-install-recommends $DEPS

ADD ./DESCRIPTION /app/DESCRIPTION
RUN Rscript -e "install.packages('devtools')"
RUN Rscript -e "devtools::install(pkg = '.', dependencies = TRUE, local = FALSE)"

# https://github.com/bazelbuild/rules_closure/pull/353#issuecomment-619092111
# https://stackoverflow.com/questions/33379393/docker-env-vs-run-export
ADD . /app
RUN Rscript -e "webdriver::install_phantomjs()"
ENV OPENSSL_CONF=/etc/ssl/
RUN Rscript -e "install.packages('.', repos = NULL, type = 'source')"
