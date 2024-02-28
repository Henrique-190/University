CC = gcc
BIN = bin/
SRC = src/
INCLUDES = include/
EXEC = k_means
CFLAGS = -O2 -funroll-loops -fopenmp -ftree-vectorize

CP_CLUSTERS = 4
THREADS = 2


.DEFAULT_GOAL = k_means

k_means: $(SRC)k_means.c $(BIN)utils.o
	$(CC) $(CFLAGS) $(SRC)k_means.c $(BIN)utils.o -o $(BIN)$(EXEC)

$(BIN)utils.o: $(SRC)utils.c $(INCLUDES)utils.h
	$(CC) $(CFLAGS) -c $(SRC)utils.c -o $(BIN)utils.o

estat:
	sudo perf stat -e L1-dcache-load-misses -M cpi ./$(BIN)$(EXEC) 10000000 $(CP_CLUSTERS) $(THREADS)

clean:
	rm -r bin/*

run:
	./$(BIN)$(EXEC)

runseq:
	./$(BIN)$(EXEC) 10000000 $(CP_CLUSTERS)

runpar:
	./$(BIN)$(EXEC) 10000000 $(CP_CLUSTERS) $(THREADS)

report:
	perf record ./$(BIN)$(EXEC) 10000000 $(CP_CLUSTERS) $(THREADS)
	perf report