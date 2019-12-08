#!/usr/bin/env bash

set -eu

go build -mod=vendor ./cmd/todo-list-server
docker-compose build

go build -mod=vendor -o terraform-provider-todo_v0.0.1 ./terraform-provider-todo
cd terraform-provider-todo
make testacc TEST=./todo
