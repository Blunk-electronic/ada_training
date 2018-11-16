-- This is a simple ada program, that demonstrates 
-- how to call an external program.

with ada.text_io;				use ada.text_io;
with gnat.os_lib;   			use gnat.os_lib;

procedure call_external_program_2 is
	pid : gnat.os_lib.process_id;
begin
	pid := non_blocking_spawn
		(  
		program_name           => "/bin/ls",
		args                   => 	(
									1=> new string'("-l")
									),
		output_file_descriptor => standout
		);

	-- execution continues here without
	-- waiting for program_name to finish.
	put_line ("done");
	
end call_external_program_2;
