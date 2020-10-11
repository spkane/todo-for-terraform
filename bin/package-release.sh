#!/usr/bin/env bash

set -eu

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

cd "$DIR/../cmd/todo-list-server/pkg/"

rm -f *.tar.gz

for i in $(ls -C1 .); do
  cd ${i}
  tar -cvzf ../todo_list_server-${i}.tar.gz *
  cd ..
done

cd "$DIR/../terraform-provider-todo/pkg/"

rm -f *.tar.gz

for i in $(ls -C1 .); do
  cd ${i}
  tar -cvzf ../terraform-provider-todo-${i}.tar.gz *
  cd ..
done

exit 0
