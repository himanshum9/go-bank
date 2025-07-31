.PHONY: createdb postgres dropdb sqlc
postgres:
	docker run --name postgres-bank -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres:17

createdb:
	docker exec -it postgres-bank createdb --username=postgres --owner=postgres simple_bank

dropdb:
	#kill the active session then drop the db
	docker exec -it postgres-bank psql -U postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'simple_bank';"
	docker exec -it postgres-bank dropdb -U postgres simple_bank

migrateup:
	migrate -path db/migration/ -database "postgresql://postgres:postgres@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration/ -database "postgresql://postgres:postgres@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate