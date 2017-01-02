-- This is a simple ada program, that 
-- shows how to handle directories.

with ada.text_io; use ada.text_io;
with ada.directories; use ada.directories;

procedure directory_and_file_ops_2 is

	file : string (1..19) := "dummy_text_file.txt";
	s : file_size;
begin
	put_line (full_name (file)); -- absolute path
	put_line (containing_directory (file));
	
	put_line (simple_name (file)); 
	put_line (base_name (file)); 	
	put_line (extension (file)); 		

	s := size(file);
	put_line (file_size'image(s) & " bytes");

end directory_and_file_ops_2;
