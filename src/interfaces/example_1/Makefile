TARGET = example_1

VPATH = ../lib
OBJS = $(TARGET).o pac_1.o
PREFIX = $(HOME)
BINDIR = $(PREFIX)/bin

# compile
.adb.o:
	gcc -c -gnat2012 $< -I $(VPATH)
.SUFFIXES: .adb .o

# link
$(TARGET): $(OBJS)
	gnatbind -x $(TARGET).ali; gnatlink $(TARGET).ali
	#gnat xref *.ali -v > tags

install:
	install -D $(TARGET) $(BINDIR)/$(TARGET)

uninstall:
	-rm $(BINDIR)/$(TARGET)

clean:
	rm -f *.o *.ali $(TARGET)

