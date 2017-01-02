-- This is a simple ada program, that 
-- shows how to handle directories.

with ada.text_io; use ada.text_io;
with ada.directories; use ada.directories;

procedure directory_and_file_ops_1 is

	dir_name : string (1..3) := "log";
begin
	put_line ("the current working directory is: " & current_directory);
	create_directory ( dir_name ); -- created in current working directory
	
	if exists ( dir_name ) then
		put_line ("directory '" & dir_name & "' created");
	end if;
	
	delete_directory ( dir_name ); -- clean up

end directory_and_file_ops_1;
