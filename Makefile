# Make target default to x86_64
TARGET := x86_64

# ARCH Check
SUPPORTED_ARCHS := x86_64

ifeq ($(filter $(TARGET),$(SUPPORTED_ARCHS)),)
    $(error Error: Leaf currently doesn't support $(TARGET))
else
    include arch/$(TARGET)/config.mk
endif

# Target defs
TARGET_FORMAT := $(TARGET)-elf
TARGET_PATH := arch/$(TARGET)
TARGET_ROOT := $(TARGET_PATH)/public

KERNEL := Leaf
KERNEL_DIR := kernel

# Get the output type for NASM_FLANGS
ifeq ($(TARGET),x86_64)
    NASM_OUT := elf64
else
    $(error Error: Leaf currently doesn't support $(TARGET))
endif

# Get the output type for CC_FLAGS
ifeq ($(TARGET),x86_64)
    CC_OUT := x86-64
else
    $(error Error: Leaf currently doesn't support $(TARGET))
endif


# Tools
CC := $(TARGET_FORMAT)-gcc
AS := $(TARGET_FORMAT)-as
NASM := nasm
LD := $(TARGET_FORMAT)-ld
LD_CONF := $(TARGET_PATH)/linker.ld

# Tool Flags
CC_FLAGS := \
	-g \
	-O2 \
	-pipe \
    -O0 \
    -I$(TARGET_PATH) \
    -I$(KERNEL_DIR) \
    -Wall \
    -Wextra \
    -std=gnu11 \
    -ffreestanding \
    -fno-stack-protector \
    -fno-stack-check \
    -fno-lto \
    -fno-PIE \
    -fno-PIC \
    -m64 \
    -march=$(CC_OUT) \
    -mabi=sysv \
    -mcmodel=kernel \
    -mno-80387 \
    -mno-red-zone \
    -DPRINTF_DISABLE_SUPPORT_FLOAT \
    -DHEAP_ACCESSABLE \
    -msse \
    -mgeneral-regs-only \
    -DSUPPORT_FLOAT \
    -Wimplicit-function-declaration \
    -Wdiv-by-zero \
    -Wunused-variable

LD_FLAGS := \
	-nostdlib \
	-static  \
	-m elf_x86_64 \
	-z max-page-size=0x1000 \
	-T $(LD_CONF)

NASM_FLAGS := \
	-Wall \
	-f $(NASM_OUT)

# Files
CFILES := $(shell cd $(KERNEL_DIR) && find -L * -type f -name '*.c')
ASFILES := $(shell cd $(KERNEL_DIR) && find -L * -type f -name '*.S')
NASMFILES := $(shell cd $(KERNEL_DIR) && find -L * -type f -name '*.asm')
OBJ := $(addprefix build/,$(CFILES:.c=.c.o) $(ASFILES:.S=.S.o) $(NASMFILES:.asm=.asm.o))
HEADER_DEPS := $(addprefix build/,$(CFILES:.c=.c.d) $(ASFILES:.S=.S.d))

# Targets
.PHONY: all
all: bin/$(KERNEL)

bin/$(KERNEL): Makefile $(LD_CONF) $(OBJ)
	@printf "  LD\t$@\n"
	@mkdir -p "$$(dirname $@)"
	@$(LD) $(OBJ) $(LDFLAGS) -o $@

-include $(HEADER_DEPS)

build/%.c.o: $(KERNEL_DIR)/%.c Makefile
	@printf "  CC\t$<\n"
	@mkdir -p "$$(dirname $@)"
	@$(CC) $(CC_FLAGS) -c $< -o $@

build/%.S.o: $(KERNEL_DIR)/%.S Makefile
	@printf "  AS\t$<\n"
	@mkdir -p "$$(dirname $@)"
	@$(CC) $(CC_FLAGS) -c $< -o $@

build/%.asm.o: $(KERNEL_DIR)/%.asm Makefile
	@printf "  AS\t$<\n"
	@mkdir -p "$$(dirname $@)"
	@nasm $(NASM_FLAGS) $< -o $@

.PHONY: clean
clean:
	rm -rf bin build 