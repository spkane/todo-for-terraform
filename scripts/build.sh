#!/usr/bin/env bash

set -eu

./scripts/tf_complete_build.sh
docker-compose build

cd terraform-provider-todo
make testacc TEST=./todo
