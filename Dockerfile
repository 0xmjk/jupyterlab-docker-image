FROM ubuntu:bionic AS conda-latest
ADD installed-versions /etc/
RUN export $(cat /etc/installed-versions) && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y npm pandoc texlive-xetex curl git && \
    ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get clean
# install conda
RUN \
  export $(cat /etc/installed-versions) && \
  curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh && \
  bash /tmp/miniconda.sh -bfp /usr/local && \
  rm -rf /tmp/miniconda.sh && \
  conda install -y python=${python} && \
  conda clean -pt
# pip install but don't store downloaded
RUN export $(cat /etc/installed-versions) && \
  conda install -y numpy=${numpy} && conda clean -pt
RUN export $(cat /etc/installed-versions) && \
  conda install -y pandas=${pandas} && conda clean -pt
RUN export $(cat /etc/installed-versions) && \
  conda install -y scipy=${scipy} && conda clean -pt
RUN export $(cat /etc/installed-versions) && \
  conda install -y matplotlib=${matplotlib} && conda clean -pt
RUN export $(cat /etc/installed-versions) && \
  conda install -c conda-forge -y altair=${altair} && conda clean -pt
RUN export $(cat /etc/installed-versions) && \
  pip install --no-cache-dir requests==${requests}
RUN export $(cat /etc/installed-versions) && \
  pip install --no-cache-dir qgrid==${qgrid}
RUN pip install --no-cache-dir git+git://github.com/0xmjk/pandas-qgrid-mixin
# install jupyterlab, and cleanup nodejs yarn cache
RUN  export $(cat /etc/installed-versions) && \
  pip install --no-cache-dir --upgrade https://github.com/jupyterlab/jupyterlab/archive/${jupyterlab}.tar.gz && \
    rm -rf /usr/local/share/.cache/yarn
RUN jupyter serverextension enable --py jupyterlab
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter labextension install qgrid
RUN useradd -m jupyterlab
WORKDIR /home/jupyterlab
USER jupyterlab
ADD --chown=jupyterlab *.py /home/jupyterlab/.jupyter/
ADD --chown=jupyterlab README.ipynb /home/jupyterlab/
RUN mkdir /home/jupyterlab/persisted && \
    mkdir -p /home/jupyterlab/.local/lib/python3.6/site-packages
VOLUME /home/jupyterlab/persisted
ENV PYTHONSTARTUP=/home/jupyterlab/.jupyter/startup.py
EXPOSE 8888
ENTRYPOINT jupyter lab

FROM conda-latest AS conda-cling-latest
USER root
RUN conda install -y xeus-cling notebook -c QuantStack -c conda-forge
USER jupyterlab
