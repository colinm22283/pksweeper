export ASM=/opt/cross/bin/i686-elf-as
export ASMFLAGS=

export LD=/opt/cross/bin/i686-elf-ld
export LDFLAGS=-T$(SOURCE_DIR)/linker.ld

export INCLUDE_DIRS=$(SOURCE_DIR)/include

export BUILD_DIR=$(CURDIR)/build
export BIN_DIR=$(BUILD_DIR)/bin
export OBJ_DIR=$(BUILD_DIR)/obj
export SOURCE_DIR=$(CURDIR)/firmware
export MAKE_DIR=$(CURDIR)/make

export MAKE_SCRIPTS=$(MAKE_DIR)/targets.mk

.PHONY: $(BIN_DIR)/pksweeper
$(BIN_DIR)/pksweeper:
	cd firmware && $(MAKE) $(BIN_DIR)/pksweeper

$(BUILD_DIR)/pksweeper.img: $(BIN_DIR)/pksweeper
	cat $(BIN_DIR)/pksweeper > $(BUILD_DIR)/pksweeper.img

.PHONY: emulate
emulate: $(BUILD_DIR)/pksweeper.img
	cd $(BUILD_DIR) && qemu-system-x86_64 -no-reboot -drive file=pksweeper.img,format=raw -vga std -d cpu_reset -m 6G

.PHONY: emulate-debug
emulate-debug: $(BUILD_DIR)/pksweeper.img
	cd $(BUILD_DIR) && qemu-system-x86_64 -no-reboot -s -S -drive file=pksweeper.img,format=raw -vga std -d cpu_reset -m 6G


.DEFAULT: all
.PHONY: all
all: $(BUILD_DIR)/pksweeper.img
