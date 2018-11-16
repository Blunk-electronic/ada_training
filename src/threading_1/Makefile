TARGET = threading_1

$(TARGET): $(TARGET).adb
	gprbuild
	gnat xref *.ali -v > tags

clean:
	rm -f b__* tags *.bexch *.o *.ali $(TARGET) $(TARGET).adb.stderr $(TARGET).adb.stdout 
	

