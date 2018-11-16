-- This is a simple ada program, that demonstrates 
-- how to call an external program.

with ada.text_io;				use ada.text_io;
with gnat.os_lib;   			use gnat.os_lib;

procedure call_external_program_1 is
	result : natural;
begin
	spawn  -- blocking
		(  
		program_name           => "/bin/ls",
		args                   => 	(
									1=> new string'("-l")
									),
		output_file_descriptor => standout,
		return_code            => result
		);

	-- execution continues here after 
	-- program_name has finished.
	if result = 0 then
		put_line ("done");
	else
		put_line ("program execution failed");
	end if;

end call_external_program_1;
