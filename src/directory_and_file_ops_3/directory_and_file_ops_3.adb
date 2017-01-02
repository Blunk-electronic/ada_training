-- This is a simple ada program, that 
-- shows how to handle directories.

with ada.text_io; use ada.text_io;
with ada.directories; use ada.directories;

procedure directory_and_file_ops_3 is
	
	handle : ada.text_io.file_type;
	
begin
	create (
			file => handle,
			mode => out_file, -- data will go into the file
			name => compose ( 
					containing_directory => current_directory,
					name => "dummy",
					extension => "txt" )
		   );

	put_line ( handle, "This is meaningless stuff.");
	close ( handle );

end directory_and_file_ops_3;
