all: help

help: ## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

serve: db-run deps ## Serve dev application
	mix phx.server

deps: deps-mix deps-node ## Setup dependencies

deps-mix: ## Setup mix dependencies
	mix deps.get --force

db-create: ## Create db
	mix ecto.create

deps-node: ## Setup node dependencies
	cd assets && npm install

db-run: ## Run database
	docker-compose up -d
