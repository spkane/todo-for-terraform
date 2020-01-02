#!/usr/bin/env bash

set -eu

export TF="terraform12"

cd "${GOPATH}/src/github.com/spkane/todo-for-terraform"
./scripts/build.sh
docker-compose up -d
# Add something to import as a data source
curl -i http://127.0.0.1:8080/ -X POST -H 'Content-Type: application/spkane.todo-list.v1+json' -d '{"description":"go shopping","completed":false}'
cd terraform-tests
rm -f terraform-provider-todo
cp ../terraform-provider-todo/bin/terraform-provider-todo .
${TF} init --get --upgrade=true
TF_LOG=debug ${TF} apply
curl -i http://127.0.0.1:8080/
docker-compose down
rm -f terraform-provider-todo

