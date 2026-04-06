BINPATH := bin
BINARY  := hello-main

GOCMD   := go
GOBUILD := $(GOCMD) build
GORUN   := $(GOCMD) run
GOTEST  := $(GOCMD) test
GOFMT   := $(GOCMD) fmt
GOVET   := $(GOCMD) vet

.DEFAULT_GOAL := help

.PHONY: build
build: ## Build the binary
	mkdir -p $(BINPATH)
	$(GOBUILD) -o $(BINPATH)/$(BINARY) .

.PHONY: clean
clean: ## Remove build artifacts
	rm -rf $(BINPATH)

.PHONY: fmt
fmt: ## Format Go source files
	$(GOFMT) ./...

.PHONY: help
help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-10s %s\n", $$1, $$2}'

.PHONY: lint
lint: vet ## Run linter (requires golangci-lint)
	golangci-lint run ./...

.PHONY: run
run: ## Run the program
	$(GORUN) .

.PHONY: test
test: ## Run tests
	$(GOTEST) -v ./...

.PHONY: tidy
tidy: ## Tidy go modules
	$(GOCMD) mod tidy

.PHONY: vet
vet: ## Run go vet
	$(GOVET) ./...
