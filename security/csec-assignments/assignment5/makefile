CC=gcc
CFLAGS=-Wall -Wextra -O2
LDLIBS=-lpcap
TARGET=pcap_ex

all: $(TARGET)

$(TARGET): pcap_ex.c
	$(CC) $(CFLAGS) -o $(TARGET) pcap_ex.c $(LDLIBS)

clean:
	$(RM) $(TARGET) *.o log.txt
