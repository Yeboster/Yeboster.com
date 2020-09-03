serve: db-run
	mix phx.server

db-run:
	docker-compose up -d