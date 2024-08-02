# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: samusanc <samusanc@student.42madrid>       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/06/24 19:28:25 by samusanc          #+#    #+#              #
#    Updated: 2024/08/02 21:57:12 by samusanc         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

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

all: build up

build:
ifeq ($(COMPOSE_FILE),$(INVALID_FILE))
	@echo "Srry building not valid for this OS, try to be a normal human being..."
else
	@echo "./srcs/docker-compose$(COMPOSE_FILE).yml"
	xhost +
	docker-compose -f ./srcs/docker-compose$(COMPOSE_FILE).yml build
	docker image prune -f
endif

up:
ifeq ($(COMPOSE_FILE),$(INVALID_FILE))
	@echo "Srry building not valid for this OS, try to be a normal human being..."
else
	@echo "./srcs/docker-compose$(COMPOSE_FILE).yml"
	docker-compose -f ./srcs/docker-compose$(COMPOSE_FILE).yml up --build
endif

down:
ifeq ($(COMPOSE_FILE),$(INVALID_FILE))
	@echo "Srry building not valid for this OS, try to be a normal human being..."
else
	docker-compose -f ./srcs/docker-compose$(COMPOSE_FILE).yml down
endif

stop:
	if [ -n "$$(docker ps -aq)" ]; then \
		docker stop $$(docker ps -aq); \
	fi

delvol:
	if [ -n "$$(docker volume ls -qf dangling=true)" ]; then \
		docker volume rm $$(docker volume ls -qf dangling=true); \
	fi

re: fclean all

fclean: down clean delvol
	docker system prune -a -f

clean: stop
	if [ -n "$$(docker ps -aq)" ]; then \
		docker rm $$(docker ps -aq); \
	fi

.PHONY: all fclean clean up down stop delvol
