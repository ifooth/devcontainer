PREFIX                  ?= $(shell pwd)/bin/
GO                      ?= go
FIRST_GOPATH            := $(firstword $(subst :, ,$(shell $(GO) env GOPATH)))
GOHOSTOS                ?= $(shell $(GO) env GOHOSTOS)
GOHOSTARCH              ?= $(shell $(GO) env GOHOSTARCH)
BUILDTIME                = ${shell TZ=Asia/Shanghai date +%Y-%m-%dT%T%z}
GOBUILD                  = CGO_ENABLED=0 go build -trimpath

ifdef VERSION
    VERSION=${VERSION}
else
    VERSION=$(shell git describe --tags --always --dirty="-dirty")
endif

ifdef GITCOMMIT
    GITCOMMIT=${GITCOMMIT}
else
    GITCOMMIT=$(shell git rev-parse HEAD)
endif

# Go Reproducible Build
ifdef REPRODUCIBLE_BUILD
	GOBUILD=CGO_ENABLED=0 go build -trimpath -ldflags=-buildid=
	BUILDTIME=0
endif

.PHONY: tidy
tidy:
	@go mod tidy

.PHONY: test
test:
	@go test -coverprofile=./cover.out -covermode=atomic ./...

.PHONY: lint
lint:
	@golangci-lint run --issues-exit-code=0 --fix ./...

.PHONY: benchmark
benchmark:
	@go test -benchmem -bench=. ./...

.PHONY: generate
generate:
	@go generate ./...

.PHONY: docs
docs:
	@swag init --outputTypes go,json -g ./cmd/dev/server.go --exclude ./
	@swag fmt -g ./cmd/dev/server.go --exclude ./

.PHONY: build
build:
	@echo ">> rebuilding binaries"
	${GOBUILD} -o ./bin/dev ./cmd/dev
