BINPATH := bin
BINARY := hello-main

BUILDPATH := build

.DEFAULT_GOAL := help

.PHONY: build
build: init ## Build the binary
	go build -o $(BINPATH)/$(BINARY) .

.PHONY: clean
clean: ## Remove build artifacts
	rm -rf $(BINPATH)

.PHONY: coverage
coverage: init ## Run tests and fail if coverage is below 80%
	go test -coverprofile=$(BUILDPATH)/coverage.out -coverpkg=./hello/... ./...
	@go tool cover -func=$(BUILDPATH)/coverage.out | awk '/^total:/{gsub(/%/,"",$$3); if($$3+0<80){print "FAIL: coverage "$$3"% is below 80%"; exit 1} else {print "PASS: coverage "$$3"%"}}'

.PHONY: fmt
fmt: ## Format Go source files
	go fmt ./...

.PHONY: help
help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-10s %s\n", $$1, $$2}'

.PHONY: init
init: ## Initialize the project
	mkdir -p $(BINPATH)
	mkdir -p $(BUILDPATH)

.PHONY: lint
lint: vet ## Run linter (requires golangci-lint)
	golangci-lint run ./...

.PHONY: run
run: ## Run the program
	go run .

.PHONY: test
test: ## Run tests
	go test -v ./...

.PHONY: tidy
tidy: ## Tidy go modules
	go mod tidy

.PHONY: vet
vet: ## Run go vet
	go vet ./...
