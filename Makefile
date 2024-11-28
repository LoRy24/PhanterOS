# ----------------------- #
#        Utilità          #
# ----------------------- #

# Files di utilità
UTILITY_FILES = ./out/boot/utils/printing.o

# Compila il file printing.o
./out/boot/utils/printing.o: ./src/boot/utils/printing.s
	@echo "Compiling printing.s..."
	as --32 -o ./out/boot/utils/printing.o ./src/boot/utils/printing.s
	@echo "Compiled printing.s!"

# ----------------------- #
#       Bootloader        #
# ----------------------- #

# Files necessari per compilare il boot sector
BOOT_FILES = ./out/boot/boot.o $(UTILITY_FILES)

# Compila il file boot.s
./out/boot/boot.o: ./src/boot/boot.s
	@echo "Compiling boot.s..."
	as --32 -o ./out/boot/boot.o ./src/boot/boot.s
	@echo "Compiled boot.s!"

# Compila il boot sector
build_boot: $(BOOT_FILES)
	@echo "Building boot sector..."
	ld -m elf_i386 -T ./src/boot/boot.ld -o ./bin/boot.bin $(BOOT_FILES)
	@echo "Boot sector built!"

# ----------------------- #
#        Extended         #
#       Bootloader        #
# ----------------------- #

# Files necessari per compilare l'extender boot loader
EXTENDED_BOOT_FILES = $(UTILITY_FILES) ./out/boot/extended/extboot.o

# Compila il file extboot.s
./out/extended/extboot.o: ./src/boot/extended/extboot.s
	@echo "Compiling extboot.s..."
	as --32 -o ./out/extended/extboot.o ./src/boot/extended/extboot.s
	@echo "Compiled extboot.s!"

# Compila l'extended bootloader
build_extended_boot: $(EXTENDED_BOOT_FILES)
	@echo "Building extended bootloader..."
	ld -m elf_i386 -T ./src/boot/extended/extboot.ld -o ./bin/extboot.bin $(EXTENDED_BOOT_FILES)
	@echo "Extended bootloader built!"

# ----------------------- #
#         Utilità         #
# ----------------------- #

# Pulisce i file generati
clean:
	@echo "Cleaning up..."
	rm -rf $(BOOT_FILES)
	rm -rf $(EXTENDED_BOOT_FILES)
	rm -rf ./bin/boot.bin
	rm -rf ./bin/os.bin
	rm -rf ./bin/os.img
	@echo "Cleaned up!"

# ----------------------- #
#      Compila Tutto      #
# ----------------------- #

# Compila tutto in un file os.bin
all: clean build_boot build_extended_boot
	@echo "Building os.bin..."
	cat ./bin/boot.bin > ./bin/os.bin
	cat ./bin/extboot.bin > ./bin/os.bin
	dd if=/dev/zero bs=512 count=4096 >> ./bin/os.bin
	dd if=./bin/os.bin of=./bin/os.img conv=notrunc
	@echo "Built os.bin!"

# ----------------------- #
#       Esecuzione        #
# ----------------------- #

# Esegue il sistema operativo
run: 
	@echo "Running os.img..."
	qemu-system-i386 -hda ./bin/os.img
	@echo "Ran os.img!"

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
