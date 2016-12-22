-- This is a simple ada program, that 
-- reads a line from a file.

with ada.text_io;	use ada.text_io;

procedure file_read_1 is
	my_file : ada.text_io.file_type;
begin
	open 	(
				file => my_file,
				mode => in_file,
				name => "text.txt"
			);
	set_input(my_file);

	while not end_of_file loop
		put_line (get_line);
	end loop;

	close (my_file);
end file_read_1;
