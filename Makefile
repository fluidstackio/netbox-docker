NETBOX_VERSION ?= v4.3.2-3.3.0
ENVIRONMENT ?= dev

DOCKER_REPO := ghcr.io/fluidstackio
DOCKER_NAME := netbox-plugins-$(ENVIRONMENT)
DOCKER_TAG ?= v0.1.0
DOCKER_IMAGE := $(DOCKER_REPO)/$(DOCKER_NAME):$(DOCKER_TAG)

DOCKERFILE ?= Dockerfile.plugins

docker-build: plugin_requirements.txt configuration/*
	docker build --platform linux/amd64 --build-arg NETBOX_VERSION=$(NETBOX_VERSION) --no-cache -f $(DOCKERFILE) -t $(DOCKER_IMAGE) .

docker-push:
	docker push $(DOCKER_IMAGE)
