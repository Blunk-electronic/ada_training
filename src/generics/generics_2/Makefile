TARGET = generics_2

VPATH = ../lib
OBJS = $(TARGET).o library_with_generic.o
PREFIX = $(HOME)
BINDIR = $(PREFIX)/bin

# compile
.adb.o:
	gcc -c -gnat2012 $< -I $(VPATH)
.SUFFIXES: .adb .o

# link
$(TARGET): $(OBJS)
	gnatbind -x $(TARGET).ali; gnatlink $(TARGET).ali

install:
	install -D $(TARGET) $(BINDIR)/$(TARGET)

uninstall:
	-rm $(BINDIR)/$(TARGET)

clean:
	rm *.o *.ali $(TARGET)
	


