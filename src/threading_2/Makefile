TARGET = threading_2

$(TARGET): $(TARGET).adb
	mkdir -p obj
	gprbuild
	mv obj/threading_2 ./
	gnat xref *.ali -v > tags

clean:
	rm -f obj/* $(TARGET) tags
	

