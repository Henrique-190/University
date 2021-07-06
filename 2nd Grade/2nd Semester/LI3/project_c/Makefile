CFLAGS= -W -Wall -std=c99 -Wextra -O3 -D_GNU_SOURCE -ansi -g `pkg-config --cflags --libs glib-2.0`
GDBFLAGS=  -W -Wall -Wextra -O3 -ggdb3 -D_GNU_SOURCE -ansi 
VGFLAGS = --leak-check=full -s --show-reachable=no --track-origins=yes --keep-stacktraces=alloc-and-free --error-limit=no --num-callers=40 --show-leak-kinds=all

CC = gcc

COBJECTS:=$(patsubst src/%.c,src/%.o,$(wildcard src/*.c))
GDBOBJECTS:= $(shell find -name '*.c')

EXECUTABLE=program

$(EXECUTABLE): $(COBJECTS)
	$(CC) -o $(EXECUTABLE) $(COBJECTS) $(CFLAGS)


clean: 
	rm -rf src/*.o $(EXECUTABLE) progGDB *.o	


gdb:
	gcc -o  progGDB $(GDBFLAGS)  $(GDBOBJECTS) -W -Wall -Wextra -O2 -D_GNU_SOURCE `pkg-config --cflags --libs glib-2.0`

grind:
	valgrind $(VGFLAGS) ./$(EXECUTABLE)

run: 
	./$(EXECUTABLE)

docs:
	cd /docs && doxygen -g doxygen_config		