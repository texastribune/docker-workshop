APP=shakespeare
NS=texastribune
IMAGE=${NS}/${APP}
DB_CONTAINER=db-workshop


build:
	docker build --tag=${IMAGE} .

net:
	-docker network create foo

db: net
	docker start ${DB_CONTAINER} || docker run --detach --net=foo --name=${DB_CONTAINER} postgres:9.6

debug:
	docker run --volumes-from=${APP} --interactive=true --tty=true ${IMAGE} bash

run: db
	docker run --name=${APP} -it --rm --net=foo --publish=80:80 ${IMAGE}

clean:
	docker stop ${APP} && docker rm ${APP} || true
	docker stop ${DB_CONTAINER} && docker rm ${DB_CONTAINER}

interactive:
	docker run --rm --interactive --tty --name=${APP} ${NS}/${APP} bash
