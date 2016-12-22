-- This is a simple ada program, that 
-- writes a few bytes in a file.

with ada.text_io;	use ada.text_io;
with interfaces;	use interfaces;
with ada.sequential_io;

procedure file_write_2 is

	package byte_io is new ada.sequential_io(unsigned_8);
	--use byte_io;
	my_file : byte_io.file_type;

begin

	byte_io.create 	(
					file => my_file,
					mode => byte_io.out_file,
					name => "some_bytes.bin"
					);

	byte_io.write (my_file, 16#A1#);
	byte_io.write (my_file, 16#56#);
	byte_io.write (my_file, 16#F4#);
	byte_io.close (my_file);

end file_write_2;
