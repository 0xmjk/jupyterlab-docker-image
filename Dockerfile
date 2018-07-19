FROM ubuntu:latest
RUN apt-get update
RUN apt-get install -y python3 python3-dev python3-pip npm pandoc
RUN pip3 install numpy==1.14.5 \
                 pandas==0.23.3 \
                 scipy==1.1.0 \
                 matplotlib==2.2.2 \
                 altair==2.1.0
RUN pip3 install --upgrade https://github.com/jupyterlab/jupyterlab/archive/v0.33.0rc1.tar.gz
RUN jupyter serverextension enable --py jupyterlab
RUN useradd -m jupyterlab
WORKDIR /home/jupyterlab
USER jupyterlab
ADD jupyter_notebook_config.py /home/jupyterlab/.jupyter/
ADD README.ipynb /home/jupyterlab/
EXPOSE 8888
ENTRYPOINT jupyter lab
