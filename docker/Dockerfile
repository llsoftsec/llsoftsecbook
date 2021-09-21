# syntax=docker/dockerfile:1
FROM ubuntu:20.04
# install pandoc and texlive dependencies
RUN apt-get update && apt-get install -y wget perl pandoc make\
    && rm -rf /var/lib/apt/lists/*
# Install from stable Texlive 2020 final repo
RUN cd /root && \
    wget https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2020/install-tl-unx.tar.gz && \
    mkdir install-tl-unx && \
    tar -zxvf install-tl-unx.tar.gz -C install-tl-unx --strip-components=1 && \
    echo "selected_scheme scheme-minimal" >> texlive.profile && \
    mkdir texlive && \
    TEXLIVE_INSTALL_PREFIX=/texlive ./install-tl-unx/install-tl \
        -profile texlive.profile \
        -repository https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2020/tlnet-final && \
    ln -s /texlive/2020/bin/* /texlive/bin
ENV PATH=/texlive/bin:$PATH
# install latex too (the minimal scheme selected above does not install latex)
RUN tlmgr install latex latex-bin
# packages needed for pandoc:
RUN tlmgr install amsfonts amsmath lm unicode-math iftex listings fancyvrb booktabs graphics hyperref xcolor ulem geometry setspace babel upquote microtype parskip xurl bookmark footnotehyper mdwtools kvoptions etoolbox pdftexcmds infwarerr

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
