FROM texastribune/workshop

RUN go get github.com/sosedoff/pgweb

ADD https://raw.githubusercontent.com/catherinedevlin/opensourceshakespeare/master/shakespeare.sql /app/
ADD run.sh /app/

ENV DATABASE_URL postgres://docker:docker@postgres:5432/?sslmode=disable

ENTRYPOINT /app/run.sh
EXPOSE 80
