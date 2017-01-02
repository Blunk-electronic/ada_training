-- This is a simple ada program, that 
-- demonstrates the exit status.

with ada.text_io; use ada.text_io;
with ada.command_line; use ada.command_line;

procedure environment_3 is

	e : exit_status := failure;
	
begin
	if argument_count > 0 then
		put_line ("everything fine");
		e := success;
	else
		put_line ("error: arguments missing !");		
	end if;

	set_exit_status (e);
	
end environment_3;
