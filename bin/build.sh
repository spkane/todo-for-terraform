#!/usr/bin/env bash

set -eu -o pipefail

./bin/tf_complete_build.sh
docker compose build

cd terraform-provider-todo
make testacc TEST=./todo
