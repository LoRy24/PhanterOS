# ----------------------- #
#       Bootloader        #
# ----------------------- #

# Files necessari per compilare il boot sector
BOOT_FILES = ./out/boot/boot.o ./out/boot/printing.o

# Compila il file boot.s
./out/boot/boot.o: ./src/boot/boot.s
	@echo "Compiling boot.s..."
	as --32 -o ./out/boot/boot.o ./src/boot/boot.s
	@echo "Compiled boot.s!"

# Compila il file printing.o
./out/boot/printing.o: ./src/boot/printing.s
	@echo "Compiling printing.s..."
	as --32 -o ./out/boot/printing.o ./src/boot/printing.s
	@echo "Compiled printing.s!"

# Compila il boot sector
build_boot: $(BOOT_FILES)
	@echo "Building boot sector..."
	ld -m elf_i386 -T ./src/boot/boot.ld -o ./bin/boot.bin $(BOOT_FILES)
	@echo "Boot sector built!"

# ----------------------- #
#         Utilità         #
# ----------------------- #

# Pulisce i file generati
clean:
	@echo "Cleaning up..."
	rm -rf $(BOOT_FILES)
	rm -rf ./bin/boot.bin
	rm -rf ./bin/os.bin
	@echo "Cleaned up!"

# ----------------------- #
#      Compila Tutto      #
# ----------------------- #

# Compila tutto in un file os.bin
all: clean build_boot
	@echo "Building os.bin..."
	cat ./bin/boot.bin > ./bin/os.bin
	@echo "Built os.bin!"

# ----------------------- #
#       Esecuzione        #
# ----------------------- #

# Esegue il sistema operativo
run: 
	@echo "Running os.bin..."
	qemu-system-i386 -hda ./bin/os.bin
	@echo "Ran os.bin!"

# ----------------------- #
#         Docker          #
# ----------------------- #

# Configurazioni di docker
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
