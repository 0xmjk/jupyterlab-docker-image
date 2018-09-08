FROM ubuntu:bionic
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-dev npm pandoc texlive-xetex curl git && \
    ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get clean
# install newest pip -- ubuntu:bionic debs have only pip 9
RUN curl https://bootstrap.pypa.io/get-pip.py | python3
# pip install but don't store downloaded
RUN pip3 install --no-cache-dir numpy==1.15.0
RUN pip3 install --no-cache-dir pandas==0.23.4
RUN pip3 install --no-cache-dir scipy==1.1.0
RUN pip3 install --no-cache-dir matplotlib==2.2.2
RUN pip3 install --no-cache-dir altair==2.1.0
RUN pip3 install --no-cache-dir requests==2.19.1
RUN pip3 install --no-cache-dir qgrid==1.1.1
RUN pip3 install --no-cache-dir git+git://github.com/0xmjk/pandas-qgrid-mixin
# install jupyterlab, and cleanup nodejs yarn cache
ENV JUPYTER_LAB_TAG=v0.33.6
RUN pip3 install --no-cache-dir --upgrade https://github.com/jupyterlab/jupyterlab/archive/${JUPYTER_LAB_TAG}.tar.gz && \
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
