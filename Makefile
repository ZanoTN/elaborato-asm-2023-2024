# Makefile for the assembly project

# Compiler and linker
ASM = nasm
LD = gcc

# Compiler and linker flags
ASM_FLAGS = -f elf64
LD_FLAGS = -no-pie

# Source directory
SRC_DIR = src_2

# Source files (list all assembly source files)
SOURCES = $(wildcard $(SRC_DIR)/*.asm)

# Object files (derived from source files)
OBJECTS = $(SOURCES:.asm=.o)

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
