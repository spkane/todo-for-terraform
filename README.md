# Todo for Terraform

* Requires (recent versions, but approximate):
  * go 1.13.X (compiling)
  * docker 19.X (build & test scripts)
  * docker-compose 1.24.X (build & test scripts)

## Todo Server

### Build

```
./scripts/build.sh
```

### Usage

```
curl -i http://127.0.0.1:8080/
curl -i http://127.0.0.1:8080/ -d "{\"description\":\"message $RANDOM\"}" -H 'Content-Type: application/spkane.todo-list.v1+json'
curl -i http://127.0.0.1:8080/ -d "{\"description\":\"message $RANDOM\",\"completed\":false}" -H 'Content-Type: application/spkane.todo-list.v1+json'
curl -i http://127.0.0.1:8080/ -d "{\"description\":\"message $RANDOM\",\"completed\":false}" -H 'Content-Type: application/spkane.todo-list.v1+json'
curl -i http://127.0.0.1:8080/3 -X PUT -H 'Content-Type: application/spkane.todo-list.v1+json' -d '{"description":"go shopping",\"completed\":true}'
curl -i http://127.0.0.1:8080/1 -X DELETE -H 'Content-Type: application/spkane.todo-list.v1+json'
curl -i http://127.0.0.1:8080/3 -X DELETE -H 'Content-Type: application/spkane.todo-list.v1+json'
curl -i http://127.0.0.1:8080
```

## Terraform Provider

### Build & Test

```
./scripts/build.sh
```

The build script runs the Integration tests. If you want to run real local terraform tests, you can run this script:

```
./scripts/tests_manual.sh
```

---

* *NOTE*: The todo server code for this project was directly forked from:
  * [github.com/go-swagger](https://github.com/go-swagger/go-swagger/tree/master/examples/tutorials/todo-list/server-complete)


## TODOs

* https setup
