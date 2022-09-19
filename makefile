PGPASSWORD=$(shell if [ -z $${DB_PASS} ]; then echo 'changeme'; else echo $$DB_PASS; fi)

all: help

help: ## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

serve: db-run deps ## Serve dev application
	mix phx.server

shell: db-run deps ## Run project shell
	iex -S mix

db-create: ## Create db
	mix ecto.create

db-shell: ## Opens a psql shell
	docker-compose run --rm -e 'PGPASSWORD=$(PGPASSWORD)' db psql -h db -U yeboster

db-run: ## Run database
	docker-compose up -d db

deps: deps-mix deps-node ## Setup dependencies

deps-mix: ## Setup mix dependencies
	mix deps.get --force

deps-node: ## Setup node dependencies
	cd assets && npm install
