# Todo for Terraform

* Requires:
  * go (compiling)
  * docker (build & test scripts)
  * docker-compose (build & test scripts)

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
./scripts/test.sh
```

---

* *NOTE*: The todo server code for this project was directly forked from:
  * https://github.com/go-swagger/go-swagger/tree/master/examples/tutorials/todo-list/server-complete


## TODOs

* https setup
* go tests
