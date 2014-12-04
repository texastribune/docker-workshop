output: /app/out.html
# theme: jdan/cleaver-retro
# theme: matmuchrapna/cleaver-ribbon
# theme: sudodoki/reveal-cleaver-theme
--


### Overview

- setup
- review
- publishing ports
- linking
- volumes
- Dockerfiles
- Benedick or Beatrice? Who spoke more?
- how we're using it now
- debugging
- build context

---


### Install boot2docker

https://docs.docker.com/installation/mac/

    $ docker version
    Client version: 1.3.2
    [...]
    Server version: 1.3.2

---

### Setup

```
docker pull texastribune/workshop
docker pull texastribune/postgres
docker pull x110dc/rundeck

git clone git@github.com:texastribune/docker-workshop.git
git clone git@github.com:texastribune/tribtalk.git
```

---

### Configuration - set a hostname

add this to `/etc/hosts`

    192.168.59.103 docker.local

---

### Docker Hub

    docker login

---

### image vs. container

    docker images

    docker ps

    docker ps -a

<!-- image is like a CD-ROM; container is like a laptop -->

---

### Lifecycle
![foo](lifecycle.svg)

---
### containers are isolated

```
    docker run -it texastribune/postgres
```
ports exposed to the host
```
    docker run -it -P texastribune/postgres
    docker run -it --publish=5432 texastribune/postgres

    docker run -it --publish=5432:5432 texastribune/postgres
```
---

### Linking

```
    $ docker run --detach --name=db-workshop texastribune/postgres

    $ docker run -it --rm --link=db-workshop:postgres texastribune/workshop

    # psql -U docker -h postgres
    docker=# \list
```

---
### Volumes

- are part of a container, not an image
- can be shared
- can be mounted from the host OS
- used for persistent data, logs, configuration files, backups

```
  docker inspect db-workshop
  docker run -it --rm --volumes-from=db-workshop texastribune/workshop
  # cd /var/log

```

---

### Dockerfile

```
FROM node

RUN npm install -g cleaver

CMD ["cleaver", "/app/slides.md"]

```

---

### Another Dockerfile

```
FROM texastribune/workshop

RUN go get github.com/sosedoff/pgweb

ADD file.sql /app/
ADD run.sh /app/

ENV DATABASE_URL postgres://foo:bar@baz/

ENTRYPOINT /app/run.sh

EXPOSE 80
```

### Build an image

```
cd shakespeare
docker build --tag=shakespeare .
```

---

### Build

```
    docker build --tag=shakespeare .
    Sending build context to Docker daemon  5.12 kB
    Step 0 : FROM texastribune/workshop
    ---> fcdd4b3add57
    Step 1 : RUN go get github.com/sosedoff/pgweb
    ---> 0696f5f50ae9
    Step 2 : ADD
    https://raw.githubusercontent.com/catherinedevlin/opensourceshakespeare/master/shakespeare.sql /app/
    Downloading 15.05 MB
    [...]
    ---> 1c869280c1ef
    Step 6 : EXPOSE 80
    ---> Running in d19900919828
    ---> bee7568d8ba0
    Removing intermediate container d19900919828
    Successfully built bee7568d8ba0
```

---

###  Run it:

```
docker run --name=shakespeare -it --rm --link=db-workshop:postgres \
  --publish=80:80 shakespeare
```

---

### How we're using Docker right now:

- salaries
- local databases, elasticsearch
- Jenkins site speed testing
- Rundeck jobs refresh test databases
- email delivery for Jenkins and Rundeck
- pixcelcite
- sputnik

---

### Docker makes bootstrapping easy:

- texastribune/tribtalk
- x110dc/rundeck

---

### Docker debugging

- docker logs
- mount a volume

### Advanced

- build context
- `.dockerignore`
- caching
