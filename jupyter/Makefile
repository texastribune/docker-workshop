APP=science
NS=x110dc

build:
	docker build --tag=${NS}/${APP} .

debug:
	docker run --volumes-from=${APP} --interactive=true --tty=true ${NS}/${APP} bash

#run:
#	docker run --rm --name=${APP} --detach=true --publish=80:8000 ${NS}/${APP}

clean:
	docker stop ${APP} && docker rm ${APP}

run: build
	docker run --rm \
		--publish=80:8888 \
		--interactive \
		--tty \
		--workdir=/app \
		--volume=$$(pwd):/app \
		--name=${APP} ${NS}/${APP} jupyter notebook --ip=0.0.0.0 --no-browser --notebook-dir=/app
#		--entrypoint=jupyter \
#		--name=${APP} ${NS}/${APP} bash

push:
	docker push ${NS}/${APP}
