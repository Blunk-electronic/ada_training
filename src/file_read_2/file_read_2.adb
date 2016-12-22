-- This is a simple ada program, that 
-- writes a few bytes in a file.

with ada.text_io;	use ada.text_io;
with interfaces;	use interfaces;
with ada.sequential_io;

procedure file_read_2 is

	package byte_io is new ada.sequential_io(unsigned_8);
	my_file : byte_io.file_type;
	byte	: unsigned_8;
begin
	byte_io.open ( 	file => my_file,
					mode => byte_io.in_file,
					name => "some_bytes.bin" );

	for b in 1..3 loop
		byte_io.read (my_file, byte);
		put_line(unsigned_8'image(byte));
	end loop;
	byte_io.close (my_file);

end file_read_2;
