APP=shakespeare
NS=texastribune
IMAGE=${NS}/${APP}
DB_CONTAINER=db-workshop


build:
	docker build --tag=${IMAGE} .

db:
	docker start ${DB_CONTAINER} || docker run --detach --name=${DB_CONTAINER} texastribune/postgres

debug:
	docker run --volumes-from=${APP} --interactive=true --tty=true ${IMAGE} bash

run: db
	docker run --name=${APP} -it --rm --link=${DB_CONTAINER}:postgres --publish=80:80 ${IMAGE}

clean:
	docker stop ${APP} && docker rm ${APP} || true
	docker stop ${DB_CONTAINER} && docker rm ${DB_CONTAINER}

interactive:
	docker run --rm --interactive --tty --name=${APP} ${NS}/${APP} bash
