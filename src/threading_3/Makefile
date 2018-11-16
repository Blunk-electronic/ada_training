TARGET = threading_3

$(TARGET): $(TARGET).adb
	mkdir -p obj
	gprbuild
	mv obj/threading_3 ./
	gnat xref obj/*.ali -v > tags

clean:
	rm -f obj/* $(TARGET) tags
	

