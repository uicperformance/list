CC := gcc
LD := gcc

ROOT ?= ../..

MAKE := make
FFWD_DIR=$(ROOT)/../../codes
NPROC=$(shell nproc)

CFLAGS += -Wall -Winline $(LDLIB)
CFLAGS += -O3 -DT$(NPROC)

LDFLAGS += -lpthread -lnuma -DT$(NPROC)

.PHONY: all clean

BINS = benchmark_list_single_thread benchmark_tree_single_thread test_list_single_thread

all: $(BINS)

benchmark_list.o: benchmark_list.c benchmark_list.h
	$(CC) $(CFLAGS) -c -o $@ $<

test_list.o: test_list.c benchmark_list.h
	$(CC) $(CFLAGS) -c -o $@ $<

list_single_thread.o: list_single_thread.c benchmark_list.h 
	$(CC) $(CFLAGS) -c -o $@ $<

benchmark_list_single_thread: benchmark_list.o list_single_thread.o 
	$(LD) $(LDLIB) -o $@ $^ $(LDFLAGS)

test_list_single_thread: test_list.o list_single_thread.o 
	$(LD) $(LDLIB) -o $@ $^ $(LDFLAGS)

tree_single_thread.o: tree_single_thread.c
	$(CC) $(CFLAGS) -c -o $@ $<

benchmark_tree_single_thread: tree_single_thread.o benchmark_list.o
	$(LD) $(LDLIB) -o $@ $^ $(LDFLAGS)

clean:
	rm -f $(BINS) *.o *.so