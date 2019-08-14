GIT_ROOT = $(shell git rev-parse --show-toplevel)
GIT_COMMIT = $(shell git rev-parse HEAD)

NAME ?= ascarter-io
IMAGE_ID = $(shell docker images -q $(NAME) | head -n 1)
CONTAINER_ID = $(shell docker ps -q --filter name=$(NAME))

DOCKER_RUN_FLAGS = --rm --init -v $(GIT_ROOT):/usr/src/app -w /usr/src/app
DOCKER_RUN_TTY_FLAGS = -it

IMAGE_OBJS = $(IMAGE_ID)
GEMFILE_LOCK_OBJ = Gemfile.lock

JEKYLL_PORT ?= 4000

.DEFAULT_GOAL:= build

.PHONY: clean
clean:
	@if [[ -n "$(IMAGE_ID)" ]]; then \
		docker rmi -f $(IMAGE_OBJS); \
	fi

$(GEMFILE_LOCK_OBJ): Gemfile
	docker run $(DOCKER_RUN_FLAGS) $(DOCKER_RUN_TTY_FLAGS) --name $(NAME)-gemfile ruby:2.5 bundle install

.PHONY: build
build: $(GEMFILE_LOCK_OBJ)
	docker build --tag $(NAME):$(GIT_COMMIT) .
	docker tag $(NAME):$(GIT_COMMIT) $(NAME):latest

.PHONY: bash
bash:
	docker run $(DOCKER_RUN_FLAGS) $(DOCKER_RUN_TTY_FLAGS) --name $(NAME)-bash $(NAME):latest bash

.PHONY: serve
serve:
	docker run $(DOCKER_RUN_FLAGS) -p $(JEKYLL_PORT):4000 --name $(NAME)-server $(NAME):latest

.PHONY: new
new:
	docker run --rm -it -v $(GIT_ROOT)/new_site:/usr/src/app -w /usr/src/app --name $(NAME)-new $(NAME):latest bash

