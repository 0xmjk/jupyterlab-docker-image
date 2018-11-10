[![](https://images.microbadger.com/badges/image/0xmjk/jupyterlab-docker-image.svg)](https://microbadger.com/images/0xmjk/jupyterlab-docker-image "Get your own image badge on microbadger.com")

# 0xmjk/jupyterlab-docker-image
[0xmjk/jupyterlab-docker-image](https://github.com/0xmjk/jupyterlab-docker-image) is a JupyterLab Docker image to start you up with working in the [JupyterLab](https://github.com/jupyterlab/jupyterlab) environment.

It comes in couple flavours, tagged:

* `latest` - pure Python environment
* `conda-latest` - Conda-based environment
* `conda-cling-latest` - Conda-based environment with [Cling C++ interpreter](https://github.com/QuantStack/xeus-cling) 

## Running

Start with:
```shell
docker run -ti -v jupyterlab:/home/jupyterlab/persisted -p 8888:8888 0xmjk/jupyterlab-docker-image:latest
```

Change `:latest` to `:conda-latest` for Conda environment or `:conda-cling-latest` for Conda + Cling environment.


This will start the container using `jupyterlab` local Docker volume mounted in `persisted` folder.
It will be listening on port 8888.

Open a URL from docker's output (like the one below) in your browser:
```
Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://(9da9087a71fc or 127.0.0.1):8888/?token=e65085e9281c8b493b611beeec1e2931741d9c669d181120
```


## Example
The example notebook can be found as [README.ipynb](http://127.0.0.1:8888/lab/tree/README.ipynb) in your environment.

