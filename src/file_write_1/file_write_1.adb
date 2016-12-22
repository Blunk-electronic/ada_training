-- This is a simple ada program, that 
-- writes "hello world !" in a file.

with ada.text_io;	use ada.text_io;

procedure file_write_1 is

	my_file : ada.text_io.file_type;

begin

	create 	(
				file => my_file,
				mode => out_file,
				name => "text.txt"
			);

	put_line (my_file, "hello world !");
	close (my_file);

end file_write_1;
