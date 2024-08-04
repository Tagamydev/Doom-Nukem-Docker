# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: samusanc <samusanc@student.42madrid>       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/06/24 19:28:25 by samusanc          #+#    #+#              #
#    Updated: 2024/08/04 16:09:17 by samusanc         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DOCKER_PS := $(shell docker ps -aq)
DOCKER_VL := $(shell docker volume ls -qf dangling=true)
COMPOSE_FILE =
INVALID_FILE = -no-valid

ifeq ($(OS),Windows_NT)
	COMPOSE_FILE += -windows
	
else

	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		COMPOSE_FILE += -linux
	else
		COMPOSE_FILE += -no-valid
	endif
	
endif

all: env build up

env:
ifeq ($(COMPOSE_FILE),-linux)
	@echo "DISPLAY=${DISPLAY}" > ./srcs/.env
endif

build:
ifeq ($(COMPOSE_FILE),$(INVALID_FILE))
	@echo "Srry building not valid for this OS, try to be a normal human being..."
else
ifeq ($(COMPOSE_FILE),-linux)
	xhost +
endif
	docker compose -f ./srcs/docker-compose$(COMPOSE_FILE).yml build
	-docker image prune -f
endif

up:
ifeq ($(COMPOSE_FILE),$(INVALID_FILE))
	@echo "Srry building not valid for this OS, try to be a normal human being..."
else
	docker compose -f ./srcs/docker-compose$(COMPOSE_FILE).yml up --build
endif

down:
ifeq ($(COMPOSE_FILE),$(INVALID_FILE))
	@echo "Srry building not valid for this OS, try to be a normal human being..."
else
	docker compose -f ./srcs/docker-compose$(COMPOSE_FILE).yml down
endif

stop:
	-docker stop $(DOCKER_PS)
#if [ -n "$$(docker ps -aq)" ]; then 
#fi

delvol:
	-docker volume rm $(DOCKER_VL)
#	if [ -n "$$(docker volume ls -qf dangling=true)" ]; then 
#	fi

re: fclean all

fclean: down clean delvol
	docker system prune -a -f

clean: stop
	-docker rm $(DOCKER_PS)
#	if [ -n "$$(docker ps -aq)" ]; then
#	fi

.PHONY: all fclean clean up down stop delvol env
