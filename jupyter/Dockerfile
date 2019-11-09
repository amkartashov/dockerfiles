ARG BASE_NOTEBOOK_TAG=python-3.7.3
FROM jupyter/base-notebook:$BASE_NOTEBOOK_TAG

ARG ROSWELL_VER=19.09.12.102
USER root
RUN apt update && \
    wget https://github.com/roswell/roswell/releases/download/v${ROSWELL_VER}/roswell_${ROSWELL_VER}-1_amd64.deb \
    --quiet --output-document roswell.deb && \
    apt install -y --no-install-recommends ./roswell.deb build-essential libczmq-dev && \
    rm -f roswell.deb && \
    rm -rf /var/lib/apt/lists

# install https://github.com/jupyterhub/oauthenticator
USER ${NB_USER}
RUN pip install --user jupyter oauthenticator

# install Common Lisp kernel
USER ${NB_USER}
ENV PATH "${HOME}/.roswell/bin:${HOME}/.local/bin:${PATH}"
RUN rm -rf roswell && \
    ros install sbcl-bin && \
    ros install common-lisp-jupyter && \
    pip install --user jupyter jupyterlab && \
    jupyter serverextension enable --user --py jupyterlab && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
    jupyter nbextension enable --user --py widgetsnbextension

# install MIT Scheme kernel
ARG SCHEME_VER=10.1.10
USER root
RUN apt update && \
    apt install -y --no-install-recommends build-essential m4 pkg-config && \
    rm -rf /var/lib/apt/lists && \
    export PKG_CONFIG_PATH=/opt/conda/lib/pkgconfig && \
    wget https://ftp.gnu.org/gnu/mit-scheme/stable.pkg/${SCHEME_VER}/mit-scheme-${SCHEME_VER}-x86-64.tar.gz \
    --quiet --output-document scheme.tgz && \
    tar xf scheme.tgz && \
    cd mit-scheme-${SCHEME_VER}/src/ && \
    ./configure && make compile-microcode && make install && \
    cd ../.. && rm -rf mit-scheme-${SCHEME_VER} scheme.tgz && \
    wget https://github.com/joeltg/mit-scheme-kernel/archive/master.tar.gz \
    --quiet --output-document mit-scheme-kernel.tgz && \
    tar xf mit-scheme-kernel.tgz && \
    cd mit-scheme-kernel-master && \
    mkdir -p /usr/local/share/jupyter/kernels && \
    make && make install && \
    cd .. && rm -rf mit-scheme-kernel-master mit-scheme-kernel.tgz

USER ${NB_USER}
