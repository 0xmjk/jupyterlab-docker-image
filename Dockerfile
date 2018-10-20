FROM ubuntu:bionic
ADD installed-versions /etc/
RUN export $(cat /etc/installed-versions) && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y python3=${python} python3-dev=${python} npm pandoc texlive-xetex curl git && \
    ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get clean
# install newest pip -- ubuntu:bionic debs have only pip 9
RUN curl https://bootstrap.pypa.io/get-pip.py | python3
# pip install but don't store downloaded
RUN export $(cat /etc/installed-versions) && \
  pip3 install --no-cache-dir numpy==${numpy}
RUN export $(cat /etc/installed-versions) && \
  pip3 install --no-cache-dir pandas==${pandas}
RUN export $(cat /etc/installed-versions) && \
  pip3 install --no-cache-dir scipy==${scipy}
RUN export $(cat /etc/installed-versions) && \
  pip3 install --no-cache-dir matplotlib==${matplotlib}
RUN export $(cat /etc/installed-versions) && \
  pip3 install --no-cache-dir altair==${altair}
RUN export $(cat /etc/installed-versions) && \
  pip3 install --no-cache-dir requests==${requests}
RUN export $(cat /etc/installed-versions) && \
  pip3 install --no-cache-dir qgrid==${qgrid}
RUN pip3 install --no-cache-dir git+git://github.com/0xmjk/pandas-qgrid-mixin
# install jupyterlab, and cleanup nodejs yarn cache
RUN export $(cat /etc/installed-versions) && \
  pip3 install --no-cache-dir --upgrade https://github.com/jupyterlab/jupyterlab/archive/${jupyterlab}.tar.gz && \
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
