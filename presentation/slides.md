output: /app/out.html
# theme: jdan/cleaver-retro
# theme: matmuchrapna/cleaver-ribbon
# theme: sudodoki/reveal-cleaver-theme

---

### Intro to Docker Workshop

<img src="docker.jpg" width="100%">

---

### About Me

The Texas Tribune - nonprofit nonpartisan digital news 
(www.texastribune.org)

@x110dc (Twitter, GitHub)

danielc@pobox.com

---

### Overview

- Why?
- setup
- review
- publishing ports
- linking
- volumes
- Dockerfiles
- Benedick or Beatrice? Who spoke more?
- how we're using it now
- debugging
- build context and caching

---

### Why Docker?

- repeatable
- hosts can be generic, disposable
- laptop not cluttered
- less "it works for me"
- Dockerfile DSL is simple

---

#### Setup

<img src="docker2.jpg" width="100%">

---


### Install Docker Toolbox

https://www.docker.com/toolbox

---

### Configure environment

```
    $ eval "$(docker-machine env default)"
    $ docker version
      Client:
      Version:      1.8.3
      [...]
      Server:
      Version:      1.8.3
```
---

### Setup

```
docker pull texastribune/workshop
docker pull texastribune/postgres
docker pull x110dc/rundeck

git clone git@github.com:texastribune/docker-workshop.git
```

---

### Configuration - set a hostname

add this to `/etc/hosts`

    192.168.99.100 docker.local   # can be any name

---

### Images
<img src="cdrom.jpg" width="60%">

---
### Images
- immutable
- no state
- built in (cacheable) layers

---
### Containers

<img src="cassette.png" width="100%">

---

### Containers

- instance of image
- mutable
- disposable (usually)

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

###  Run it:

```
docker run --name=shakespeare \
  -it --rm --link=db-workshop:postgres \
  --publish=80:80 shakespeare
```

---

### Docker makes bootstrapping easy:

- x110dc/rundeck

---

### Rundeck

```
docker run --detach=true --publish=4440:4440 \
  --env=MYHOST=docker.local \
  --env=RDPASS=mypassword \
  --env=MAILFROM=foo@bar.baz \
  x110dc/rundeck
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


---
### More resources

- Docker is changing rapidly
- look for recent pub dates on articles and videos
- books are quickly out of date
- follow @jpetazzo, @frazelledazzell
