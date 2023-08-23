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
	@go test ./...

.PHONY: lint
lint:
	@golangci-lint run ./...

.PHONY: benchmark
benchmark:
	@echo ">> benchmark not support"

.PHONY: generate
generate:
	@go generate ./...

.PHONY: build
build:
	@echo ">> rebuilding binaries"
	${GOBUILD} -o ./bin/dev ./cmd/dev
