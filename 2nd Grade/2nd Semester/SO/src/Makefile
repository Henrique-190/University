CC      = gcc
CFLAGS  = -O2 -Wall -Wextra -g

all: obj/aurrasd.o bin/aurrasd  obj/aurras.o bin/aurras

server: obj/aurrasd.o bin/aurrasd
	./bin/aurrasd etc/aurrasd.conf bin/aurrasd-filters
client: obj/aurras.o bin/aurras
	./bin/aurras status


bin/aurrasd: obj/aurrasd.o obj/auxStructs.o
	$(CC) $(CFLAGS) obj/aurrasd.o -o bin/aurrasd

obj/aurrasd.o: src/aurrasd.c
	$(CC) $(CFLAGS) -c src/aurrasd.c -o obj/aurrasd.o

bin/aurras: obj/aurras.o obj/auxStructs.o
	$(CC)$(CFLAGS) obj/aurras.o obj/auxStructs.o -o bin/aurras

obj/aurras.o: src/aurras.c
	$(CC) $(CFLAGS) -c src/aurras.c -o obj/aurras.o

obj/auxStructs.o: src/auxStructs.c src/auxStructs.h
	$(CC) $(CFLAGS) -c src/auxStructs.c -o obj/auxStructs.o

stop:
	kill -s SIGTERM $(shell pidof server)


clean:
	rm obj/* tmp/* bin/aurras bin/aurrasd

test:
	bin/aurras
	bin/aurras status
	bin/aurras transform samples/sample-1-so.m4a output.m4a alto eco rapidoteste
