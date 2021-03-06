CC := gcc
LD := gcc

ROOT ?= ../..

MAKE := make
FFWD_DIR=$(ROOT)/../../codes
NPROC=$(shell nproc)

CFLAGS += -g -Wall -Winline $(LDLIB)
CFLAGS += -O3 -DT$(NPROC)

LDFLAGS += -lpthread -DT$(NPROC)

.PHONY: all clean

BINS = benchmark_list_single_thread test_list_single_thread

all: $(BINS)

benchmark_list.o: benchmark_list.c benchmark_list.h
	$(CC) $(CFLAGS) -c -o $@ $<

test_list.o: test_list.c benchmark_list.h
	$(CC) $(CFLAGS) -c -o $@ $<

list_single_thread.o: list_single_thread.c benchmark_list.h 
	$(CC) $(CFLAGS) -c -o $@ $<

list_bfl.o: list_bfl.c benchmark_list.h 
	$(CC) $(CFLAGS) -c -o $@ $<

benchmark_list_single_thread: benchmark_list.o list_single_thread.o 
	$(LD) $(LDLIB) -o $@ $^ $(LDFLAGS)

benchmark_list_bfl: benchmark_list.o list_bfl.o 
	$(LD) $(LDLIB) -o $@ $^ $(LDFLAGS)

test_list_single_thread: test_list.o list_single_thread.o 
	$(LD) $(LDLIB) -o $@ $^ $(LDFLAGS)

test_list_bfl: test_list.o list_bfl.o 
	$(LD) $(LDLIB) -o $@ $^ $(LDFLAGS)

tree_single_thread.o: tree_single_thread.c
	$(CC) $(CFLAGS) -c -o $@ $<

benchmark_tree_single_thread: tree_single_thread.o benchmark_list.o
	$(LD) $(LDLIB) -o $@ $^ $(LDFLAGS)

report.pdf: report.tex
	pdflatex report.tex
	pdflatex report.tex

clean:
	rm -f $(BINS) *.o *.so
