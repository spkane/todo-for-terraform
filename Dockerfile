FROM golang:1.13-alpine3.10 AS build

RUN apk --no-cache add \
    bash \
    gcc \
    musl-dev \
    openssl
RUN mkdir -p /go/src/github.com/spkane/todo-api-example
WORKDIR /go/src/github.com/spkane/todo-api-example
ADD . /go/src/github.com/spkane/todo-api-example
RUN go build --ldflags '-linkmode external -extldflags "-static"' ./cmd/todo-list-server

FROM alpine:3.10 AS deploy

WORKDIR /
COPY --from=build /go/src/github.com/spkane/todo-api-example/todo-list-server /

ENTRYPOINT ["/todo-list-server"]
CMD ["--scheme=http", "--host=0.0.0.0", "--port=80"]
