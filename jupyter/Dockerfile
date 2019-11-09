ARG BASE_NOTEBOOK_TAG=python-3.7.3
ARG ROSWELL_VER=19.09.12.102

FROM jupyter/base-notebook:$BASE_NOTEBOOK_TAG

USER root

RUN apt update && \
    wget https://github.com/roswell/roswell/releases/download/v${ROSWELL_VER}/roswell_${ROSWELL_VER}-1_amd64.deb \
    --quiet --output-document roswell.deb && \
    apt install -y --no-install-recommends ./roswell.deb build-essential libczmq-dev && \
    rm -f roswell.deb && \
    rm -rf /var/lib/apt/lists

USER ${NB_USER}
ENV PATH "${HOME}/.roswell/bin:${HOME}/.local/bin:${PATH}"
RUN rm -rf roswell && \
    ros install sbcl-bin && \
    ros install common-lisp-jupyter && \
    pip install --user jupyter jupyterlab && \
    jupyter serverextension enable --user --py jupyterlab && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
    jupyter nbextension enable --user --py widgetsnbextension

