### Install Docker Toolbox

https://www.docker.com/toolbox

### Configure environment

```
    $ eval "$(docker-machine env default)"
    $ docker version
      Client:
      Version:      X.X.X
      [...]
      Server:
      Version:      X.X.X
    $ docker run hello-world
```

### To view slide deck (requires Docker)

```
git clone git@github.com:texastribune/docker-workshop.git
cd presentation
make
```

### Lifecycle
![foo](lifecycle.png)


### Shakespeare

```
cd shakespeare
make run

```

### Jupyter

```
cd juptyer
make run
```