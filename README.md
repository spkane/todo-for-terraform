# Todo for Terraform

* Requires (recent versions, but approximate):
  * terraform 0.13.X+
  * go 1.15.X+ (compiling)
  * docker 20.10.X+ (build & test scripts)

## Todo Server

### Quick Start

```shell
docker run --name todo-list -p 8080:80 spkane/todo-list-server:latest
```

### Build

```shell
./bin/build.sh
```

### Usage

```shell
curl -i http://127.0.0.1:8080/
curl -i http://127.0.0.1:8080/ -d "{\"description\":\"message $RANDOM\",\"completed\":false}" -H 'Content-Type: application/spkane.todo-list.v1+json'
curl -i http://127.0.0.1:8080/ -d "{\"description\":\"message $RANDOM\",\"completed\":false}" -H 'Content-Type: application/spkane.todo-list.v1+json'
curl -i http://127.0.0.1:8080/ -d "{\"description\":\"message $RANDOM\",\"completed\":false}" -H 'Content-Type: application/spkane.todo-list.v1+json'
curl -i http://127.0.0.1:8080/3 -X PUT -H 'Content-Type: application/spkane.todo-list.v1+json' -d '{"description":"go shopping",\"completed\":true}'
curl -i http://127.0.0.1:8080/1 -X DELETE -H 'Content-Type: application/spkane.todo-list.v1+json'
curl -i http://127.0.0.1:8080/3 -X DELETE -H 'Content-Type: application/spkane.todo-list.v1+json'
curl -i http://127.0.0.1:8080
```

## Build & Test

```shell
./bin/build.sh
```

The build script runs the Integration tests. If you want to run real local terraform tests, you can run this script:

```shell
./bin/tests_manual.sh
```

## Terraform Provider

The source code for the Terraform provider can be found here:

- [spkane/terraform-provider-todo](https://github.com/spkane/terraform-provider-todo)

In your terraform HCL you will need to reference the provider with something like this:

```hcl
terraform {
  required_providers {
    todo = {
      source  = "spkane/todo"
      version = "2.0.4"
    }
  }
}
```

---

* *NOTE*: The todo server code for this project was directly forked from:
  * [github.com/go-swagger](https://github.com/go-swagger/go-swagger/tree/master/examples/tutorials/todo-list/server-complete)

## TODOs

* https setup
* Setup docker compose to use pre-built binary

