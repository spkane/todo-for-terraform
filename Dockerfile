FROM golang:1.13-alpine3.10 AS build

RUN apk --no-cache add \
    bash \
    gcc \
    musl-dev \
    openssl
RUN mkdir -p /go/src/github.com/spkane/todo-for-terraform
WORKDIR /go/src/github.com/spkane/todo-for-terraform
ADD . /go/src/github.com/spkane/todo-for-terraform
RUN go build -mod=vendor --ldflags '-linkmode external -extldflags "-static"' ./cmd/todo-list-server

FROM alpine:3.10 AS deploy

WORKDIR /
COPY --from=build /go/src/github.com/spkane/todo-for-terraform/todo-list-server /

HEALTHCHECK --interval=15s --timeout=3s \
  CMD curl -f http://127.0.0.1/?limit=1 || exit 1

ENTRYPOINT ["/todo-list-server"]
CMD ["--scheme=http", "--host=0.0.0.0", "--port=80"]
