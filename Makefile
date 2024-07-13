# Makefile for the assembly project

# Compiler and linker
ASM = nasm
LD = gcc

# Compiler and linker flags
ASM_FLAGS = -f elf64
LD_FLAGS = -no-pie

# Source files
SRC_DIR = src_2
SOURCES = $(SRC_DIR)/main.asm $(SRC_DIR)/menu.asm $(SRC_DIR)/algorithm.asm $(SRC_DIR)/penalty.asm $(SRC_DIR)/utility.asm

# Object files
OBJECTS = $(SRC_DIR)/main.o $(SRC_DIR)/menu.o $(SRC_DIR)/algorithm.o $(SRC_DIR)/penalty.o $(SRC_DIR)/utility.o

# Output executable
OUTPUT = program

# Default target
all: $(OUTPUT)

# Linking object files to create the final executable
$(OUTPUT): $(OBJECTS)
	$(LD) $(LD_FLAGS) -o $@ $^ -lc

# Rule to assemble .asm files to .o files
$(SRC_DIR)/%.o: $(SRC_DIR)/%.asm
	$(ASM) $(ASM_FLAGS) -o $@ $<

# Clean up the build
clean:
	rm -f $(OBJECTS) $(OUTPUT)

.PHONY: all clean
