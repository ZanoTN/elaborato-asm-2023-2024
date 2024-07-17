AS_FLAGS = --32 
DEBUG = -gstabs
LD_FLAGS = -m elf_i386

SRC_PATH = src_2

all: bin/out

bin/out: obj/algorithm.o obj/main.o obj/menu.o obj/penality.o obj/utility.o 
	ld $(LD_FLAGS)  obj/algorithm.o obj/main.o obj/menu.o obj/penality.o obj/utility.o -o bin/out
	
obj/algorithm.o: src_2/algorithm.s
	as $(AS_FLAGS) $(DEBUG) $(SRC_PATH)/algorithm.s -o obj/algorithm.o
	
obj/main.o: src_2/main.s
	as $(AS_FLAGS) $(DEBUG) $(SRC_PATH)/main.s -o obj/main.o
	
obj/menu.o: src_2/menu.s
	as $(AS_FLAGS) $(DEBUG) $(SRC_PATH)/menu.s -o obj/menu.o
	
obj/penality.o: src_2/penality.s
	as $(AS_FLAGS) $(DEBUG) $(SRC_PATH)/penality.s -o obj/penality.o
	
obj/utility.o: src_2/utility.s
	as $(AS_FLAGS) $(DEBUG) $(SRC_PATH)/utility.s -o obj/utility.o
	
clean:
	rm -f obj/*.o bin/pianificatore bin/EDF bin/HPF bin/read bin/stampa bin/itoa 
	