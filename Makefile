TAG=latest
PROJECT=cron
IMAGE=cron-node

build:
	docker build -t $(PROJECT)/$(IMAGE):$(TAG) -f ./Dockerfile .

rebuild:
	docker build -t $(PROJECT)/$(IMAGE):$(TAG) --no-cache -f ./Dockerfile .

create-network:
	docker network create $(PROJECT)

run:
	docker-compose -f ./docker-compose.yml --project-name $(PROJECT) up -d

restart:
	docker-compose -f ./docker-compose.yml --project-name $(PROJECT) restart
	
down:
	docker-compose -f ./docker-compose.yml --project-name $(PROJECT) down

exec:
	docker exec -it cron_seed_1 bash

logs:
	docker logs cron_seed_1 -f

# attach client node screen session, to detach from screen and keep it running (CTRL+A then CTRL+D)
cli:
	docker exec -it cron_seed_1 screen -r node 