VERSION?="0.3.32"
TEST?=./...
GOFMT_FILES?=$$(find . -not -path "./vendor/*" -type f -name '*.go')

default: test

# bin generates the releaseable binaries for Terraform
bin: fmtcheck
	@TF_RELEASE=1 sh -c "'$(CURDIR)/../bin/tf_complete_build.sh'"

# dev creates binaries for testing Terraform locally. These are put
# into ./bin/ as well as $GOPATH/bin
dev: fmtcheck
	go install .

quickdev:
	go install .

# Shorthand for building and installing just one plugin for local testing.
# Run as (for example): make plugin-dev PLUGIN=provider-aws
#plugin-dev:
#	go install github.com/hashicorp/terraform/builtin/bins/$(PLUGIN)
#	mv $(GOPATH)/bin/$(PLUGIN) $(GOPATH)/bin/terraform-$(PLUGIN)

# test runs the unit tests
# we run this one package at a time here because running the entire suite in
# one command creates memory usage issues when running in Travis-CI.
test: fmtcheck
	go list $(TEST) | xargs -t -n4 go test $(TESTARGS) -timeout=2m -parallel=4

# testacc runs acceptance tests
testacc: fmtcheck
	@if [ "$(TEST)" = "./..." ]; then \
		echo "ERROR: Set TEST to a specific package. For example,"; \
		echo "  make testacc TEST=./builtin/providers/test"; \
		exit 1; \
	fi
	@echo "==> Preparing environment"
	@docker compose down > /dev/null 2>&1
	@docker compose build
	@docker compose up -d
	@curl -i http://127.0.0.1:8080/1 -X DELETE -H 'Content-Type: application/spkane.todo-list.v1+json' > /dev/null 2>&1
	@echo "==> Creating data for testing"
	@curl -i http://127.0.0.1:8080/ -X POST -H 'Content-Type: application/spkane.todo-list.v1+json' -d '{"description":"datasource test","completed":false}' > /dev/null 2>&1
	@curl http://127.0.0.1:8080/
	@echo "==> Starting tests"
	TODO_HOST=127.0.0.1 TODO_PORT=8080 TF_ACC=1 go test $(TEST) -v $(TESTARGS) -timeout 120m
	@echo "==> Tearing down environment"
	docker compose down

# e2etest runs the end-to-end tests against a generated Terraform binary
# The TF_ACC here allows network access, but does not require any special
# credentials since the e2etests use local-only providers such as "null".
e2etest:
	TF_ACC=1 go test -v ./command/e2etest

test-compile: fmtcheck
	@if [ "$(TEST)" = "./..." ]; then \
		echo "ERROR: Set TEST to a specific package. For example,"; \
		echo "  make test-compile TEST=./builtin/providers/test"; \
		exit 1; \
	fi
	go test -c $(TEST) $(TESTARGS)

# testrace runs the race checker
testrace: fmtcheck
	TF_ACC= go test -race $(TEST) $(TESTARGS)

cover:
	go test $(TEST) -coverprofile=coverage.out
	go tool cover -html=coverage.out
	rm coverage.out

fmt:
	gofmt -w $(GOFMT_FILES)

fmtcheck:
	@sh -c "'$(CURDIR)/../bin/gofmtcheck.sh'"

# disallow any parallelism (-j) for Make. This is necessary since some
# commands during the build process create temporary files that collide
# under parallel conditions.
.NOTPARALLEL:

.PHONY: bin cover default dev e2etest fmt fmtcheck plugin-dev quickdev test-compile test testacc testrace vendor-status
