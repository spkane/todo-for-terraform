#!/bin/bash

set -eu

go build -mod=vendor ./cmd/todo-list-server
go build -mod=vendor -o terraform-provider-todo_v0.0.1 ./terraform-provider-todo
docker-compose build
