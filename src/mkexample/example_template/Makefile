TARGET = __PROJECTNAME__

VPATH = include
OBJS = $(TARGET).o
PREFIX = $(HOME)
BINDIR = $(PREFIX)/bin

# compile
.adb.o:
	gcc -c -gnat2012 $< -I include
.SUFFIXES: .adb .o

# link
$(TARGET): $(OBJS)
	gnatbind -x $(TARGET).ali; gnatlink $(TARGET).ali
	gnat xref *.ali -v > tags

install:
	install -D $(TARGET) $(BINDIR)/$(TARGET)

uninstall:
	-rm $(BINDIR)/$(TARGET)

clean:
	rm -f *.o *.ali $(TARGET)
	


