APP=workshop
NS=texastribune

build:
	docker build --tag=${NS}/${APP} .

debug:
	docker run --volumes-from=${APP} --interactive=true --tty=true ${NS}/${APP} bash

run:
	docker run --rm --name=${APP} --detach=true --publish=80:8000 ${NS}/${APP}

clean:
	docker stop ${APP} && docker rm ${APP}

interactive:
	docker run --rm --interactive --tty --name=${APP} ${NS}/${APP} bash

push:
	docker push ${NS}/${APP}
