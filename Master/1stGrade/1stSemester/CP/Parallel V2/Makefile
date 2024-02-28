CC = mpicc
BIN = bin/
SRC = src/
INCLUDES = include/
EXEC = k_means
CFLAGS = -O2 -fopenmp
RUNNER = mpirun
NPOINTS = 10000000
CP_CLUSTERS = 4
PROCESSES = 5

.DEFAULT_GOAL = k_means

k_means: $(SRC)k_means.c $(BIN)utils.o
	$(CC) $(CFLAGS) $(SRC)k_means.c $(BIN)utils.o -o $(BIN)$(EXEC)

$(BIN)utils.o: $(SRC)utils.c $(INCLUDES)utils.h
	$(CC) $(CFLAGS) -c $(SRC)utils.c -o $(BIN)utils.o

estat:
	sudo perf stat -e L1-dcache-load-misses -M cpi ./$(BIN)$(EXEC) $(NPOINTS) $(CP_CLUSTERS) $(THREADS)

clean:
	rm -r bin/*

run:
	./$(BIN)$(EXEC)

runseq:
	./$(BIN)$(EXEC) $(NPOINTS) $(CP_CLUSTERS)

runpar:
	$(RUNNER) -np $(PROCESSES) ./$(BIN)$(EXEC) $(NPOINTS) $(CP_CLUSTERS)

report:
	perf record $(RUNNER) ./$(BIN)$(EXEC) $(NPOINTS) $(CP_CLUSTERS) $(THREADS)
	perf report