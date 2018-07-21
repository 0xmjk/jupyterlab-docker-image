FROM ubuntu:bionic
RUN pip3 install --upgrade https://github.com/jupyterlab/jupyterlab/archive/v0.33.0rc1.tar.gz
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-dev npm pandoc texlive-xetex curl && \
    ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get clean
# install newest pip -- ubuntu:bionic debs have only pip 9
RUN curl https://bootstrap.pypa.io/get-pip.py | python3
# pip install but don't store downloaded
RUN pip3 install --no-cache-dir numpy==1.14.5 \
                                pandas==0.23.3 \
                                scipy==1.1.0 \
                                matplotlib==2.2.2 \
                                altair==2.1.0
RUN jupyter serverextension enable --py jupyterlab
RUN useradd -m jupyterlab
WORKDIR /home/jupyterlab
USER jupyterlab
ADD jupyter_notebook_config.py /home/jupyterlab/.jupyter/
ADD README.ipynb /home/jupyterlab/
RUN mkdir /home/jupyterlab/persisted && chown jupyterlab /home/jupyterlab/persisted
VOLUME /home/jupyterlab/persisted
EXPOSE 8888
ENTRYPOINT jupyter lab
