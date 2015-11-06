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

Slides: http://github.com/x110dc/docker-workshop

---

### Overview

- Why?
- images vs. containers
- Dockerfiles
- lifecycle
- Benedick or Beatrice? Who spoke more?
- more resources
- linking, volumes
- debugging & advanced

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


### Install Docker Toolbox

https://www.docker.com/toolbox

---

### Configure environment

```
    $ eval "$(docker-machine env default)"
    $ docker version
      Client:
      Version:      1.9.0
      [...]
      Server:
      Version:      1.9.0
    $ docker run hello-world
```
---

### What did we just do?

- client/server
- configured client to talk to server
- pulled an image
- executed that image

---

### Setup

```
docker pull texastribune/workshop
docker pull texastribune/postgres

git clone git@github.com:texastribune/docker-workshop.git
```

---

### Configuration - set a hostname

    $ docker-machine ip default

add this to `/etc/hosts`

    192.168.99.100  docker.local   # can be any name

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
FROM texastribune/workshop

RUN go get github.com/sosedoff/pgweb

ADD file.sql /app/
ADD run.sh /app/

ENV DATABASE_URL postgres://foo:bar@baz/

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
docker run --name=shakespeare \
  --interactive --tty --rm \
  --link=db-workshop:postgres \
  --publish=80:80 shakespeare
```

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
cd juptyer
make run
```
---



### Lifecycle
![foo](lifecycle.svg)



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
  --interactive --tty --rm \
  --link=db-workshop:postgres \
  --publish=80:80 shakespeare
```

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
cd juptyer
make run
```

### More resources

- blog.docker.com
- docs.docker.com
- `#docker`
- `docker help`
- Docker is changing rapidly
- look for recent pub dates on articles and videos
- books are quickly out of date
- follow @jpetazzo, @frazelledazzell
- visualizing Docker: http://bit.ly/1NpT5Ko

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

### Debugging

<img src="docker3.jpg" width="60%">


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


---

