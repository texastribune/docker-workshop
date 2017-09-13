output: /app/out.html
# theme: jdan/cleaver-retro
# theme: matmuchrapna/cleaver-ribbon
# theme: sudodoki/reveal-cleaver-theme

---

### Diving into Docker: Developing a Darn Fast, Repeatable Workflow

<img src="docker.jpg" width="100%">

---

### About Me

The Texas Tribune - nonprofit nonpartisan digital news
(www.texastribune.org)

@x110dc (Twitter, GitHub)

danielc@pobox.com

Slides: http://github.com/texastribune/docker-workshop

---

### Overview

- What? Why?
- images vs. containers
- Dockerfiles
- lifecycle
- Benedick or Beatrice? Who spoke more?
- more resources
- linking, volumes
- debugging & advanced

---

### What

> Docker containers wrap up a piece of software in a complete system that contains
> everything it needs to run: code, runtime, system tools, system libraries – anything
> you can install on a server. This guarantees that it will always run the same,
> regardless of the environment it is running in.

---

### Why Docker?

- repeatable
- hosts can be generic, disposable
- it's easy to try things out
- laptop not cluttered
- less "it works for me"
- sandbox & toolbox
- Dockerfile DSL is simple

---

### Setup

<img src="docker2.jpg" width="100%">

---


### Install Docker 

https://docs.docker.com/docker-for-mac/

or 

https://docs.docker.com/docker-for-windows/

---

### Confirm environment

```
    $ docker version
      Client:
      Version:      17.06.1-ce
      [...]
      Server:
      Version:      17.06.1-ce
    $ docker run hello-world
```
---

### What did we just do?

- client/server
- pulled an image
- executed that image

---

### Setup

```
git clone git@github.com:texastribune/docker-workshop.git

```

---

### Images
<img src="cdrom.jpg" width="60%">

---
### Images
- immutable
- no state
- built in (cacheable) layers
- Docker Hub
- official and user

---
### Containers

<img src="cassette.png" width="100%">

---

### Containers

- instance of image
- mutable
- disposable (usually)

---

### Dockerfile

```
FROM node:4.2.1   # when possible pin versions

RUN npm install -g cleaver@0.7.4

CMD ["cleaver", "/app/slides.md"]

```

---

### Another Dockerfile

```
FROM ubuntu:16.04 as builder

RUN apt-get update && apt-get install -qy zip

WORKDIR /tmp

ENV PGWEB_VERSION 0.9.8

ADD https://github.com/sosedoff/pgweb/releases/download/v$PGWEB_VERSION/pgweb_linux_amd64.zip /tmp
RUN unzip pgweb_linux_amd64.zip

FROM onjin/alpine-postgres:9.6
COPY --from=builder /tmp/pgweb_linux_amd64 /usr/bin/pgweb
RUN apk add --update python py-pip
RUN pip install postdoc

ADD https://raw.githubusercontent.com/catherinedevlin/opensourceshakespeare/master/shakespeare.sql /app/
COPY run.sh /app/

ENV DATABASE_URL postgres://postgres:postgres@postgres:5432/?sslmode=disable

ENTRYPOINT /app/run.sh
EXPOSE 80
```

---

### image vs. container

    docker images

    docker ps

    docker ps -a

<!-- image is like a CD-ROM; container is like a laptop -->

---

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
### Background and Foreground

- `docker --detach  # or -d`
- `docker --interactive --tty # or -it`

---

###  Run it:

```
docker network create foo
docker run -d --net=foo --name=postgres postgres:9.6
docker run --name=shakespeare \
  --interactive --tty --rm \
  --net=foo --name=shakespeare \
  --publish=80:80 shakespeare
```

Visit:

`http://localhost/` in your browser

---

### Who spoke more?
```
SELECT charname, speechcount
FROM character
WHERE charname LIKE 'Be%'
```

---

### Docker makes bootstrapping easy:

```
cd jupyter
make run
```
or
```
docker run -it --rm neurodebian
```
---



### Lifecycle
![lifecycle](lifecycle.png)


---

### More resources

- blog.docker.com
- docs.docker.com
- `docker help`
- Docker is changing rapidly
- look for recent pub dates on articles and videos
- books are quickly out of date
- visualizing Docker: http://bit.ly/1NpT5Ko

---

### containers are isolated

```
```
ports exposed to the host
```
    docker run -it -P postgres

    docker run -it --publish=5432 postgres

    docker run -it --publish=5432:5432 postgres
```
---

### Linking/Networking

```
    $ docker network create foo

    $ docker run --net=foo --detach --name=db-workshop postgres

    $ docker run -it --rm --net=foo postgres:9.6 bash

    # psql -U postgres -h db-workshop
    postgres=# \list
    postgres=# \dt
    
```

---
### Volumes

- are part of a container, not an image
- can be shared
- can be mounted from the host OS
- used for persistent data, logs, configuration files, backups

```
  docker inspect db-workshop
  docker run -it --rm --volumes-from=db-workshop postgres
  # cd /var/lib/postgresql/data

```

---

### Debugging

<img src="docker3.jpg" width="60%">


---

### Debugging

- docker logs
- mount a volume

---

### Advanced

- build context
- `.dockerignore`
- caching
- `docker exec`
- layers
