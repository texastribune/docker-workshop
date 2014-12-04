APP=cleaver
NS=x110dc

build:
	docker build --tag=${NS}/${APP} .

debug:
	docker run --volumes-from=${APP} --interactive=true --tty=true ${NS}/${APP} bash

run:
	docker run -it --rm --volume=$$(pwd):/app --name=${APP} ${NS}/${APP}

clean:
	docker stop ${APP} && docker rm ${APP}

interactive:
	docker run --rm --interactive --tty --name=${APP} ${NS}/${APP} bash

open: run
	open out.html
