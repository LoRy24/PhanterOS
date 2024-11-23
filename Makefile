DOCKER_IMAGE_NAME = "pantheros-env"
DOCKER_CONTAINER_NAME = "pantheros-env-container"

# Costruisce l'immagine docker per l'ambiente di sviluppo
docker_env_build:
	@echo "Building docker image $(DOCKER_IMAGE_NAME)"
	docker build . -t $(DOCKER_IMAGE_NAME)
	@echo "Docker image $(DOCKER_IMAGE_NAME) built!"

# Esegue l'ambiente di sviluppo
docker_env_run:
	@echo "Running docker image $(DOCKER_IMAGE_NAME)"
	docker run --name $(DOCKER_CONTAINER_NAME) --rm -it -v .:/pantheros $(DOCKER_IMAGE_NAME)
