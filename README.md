* *NOTE*: This code was directly forked from:
* https://github.com/go-swagger/go-swagger/tree/master/examples/tutorials/todo-list/server-complete

# todo-api example server

## Build & Test
docker build -t todo-local . && docker run -p 8080:80 todo-local

## Usage
curl -i http://127.0.0.1:56168/
curl -i http://127.0.0.1:56168/ -d "{\"description\":\"message $RANDOM\"}" -H 'Content-Type: application/spkane.todo-list.v1+json'
curl -i http://127.0.0.1:56168/ -d "{\"description\":\"message $RANDOM\"}" -H 'Content-Type: application/spkane.todo-list.v1+json'
curl -i http://127.0.0.1:56168/ -d "{\"description\":\"message $RANDOM\"}" -H 'Content-Type: application/spkane.todo-list.v1+json'
curl -i http://127.0.0.1:56168/3 -X PUT -H 'Content-Type: application/spkane.todo-list.v1+json' -d '{"description":"go shopping"}'
curl -i http://127.0.0.1:56168/1 -X DELETE -H 'Content-Type: application/spkane.todo-list.v1+json'
curl -i http://127.0.0.1:56168/3 -X DELETE -H 'Content-Type: application/spkane.todo-list.v1+json'
curl -i http://127.0.0.1:56168
