#!/usr/bin/env bash

set -eu

export TF="terraform"
export OS="darwin"
export ARCH="amd64"
export VERSION="1.1.0"

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

cd "$DIR/.."
./bin/build.sh
docker compose up -d
# Add something to import as a data source
sleep 2
curl -i http://127.0.0.1:8080/ -X POST -H 'Content-Type: application/spkane.todo-list.v1+json' -d '{"description":"go shopping","completed":false}'
cd terraform-tests
rm -f terraform-provider-todo
mkdir -p ~/.terraform.d/plugins/terraform.spkane.org/spkane/todo/${VERSION}/${OS}_${ARCH}
cp ../terraform-provider-todo/bin/terraform-provider-todo ~/.terraform.d/plugins/terraform.spkane.org/spkane/todo/${VERSION}/${OS}_${ARCH}/
${TF} init --get --upgrade=true
TF_LOG=debug ${TF} apply
curl -i http://127.0.0.1:8080/
docker compose down
rm -f ~/.terraform.d/plugins/terraform.spkane.org/spkane/todo/${VERSION}/${OS}_${ARCH}/terraform-provider-todo

