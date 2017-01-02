-- This is a simple ada program, that 
-- shows how to handle environment variables.

with ada.text_io; use ada.text_io;
with ada.environment_variables; use ada.environment_variables;

procedure environment_4 is
	
begin
	if exists ( "HOME" ) then
		put_line ("my home dir is: " & value("HOME") );
	else
		put_line ("warning: user has no home directory !");		
	end if;

	set (name => "DUMMY", value => "something_meaningful" );
	put_line ("$DUMMY=" & value("DUMMY") );	

	clear ("DUMMY");
end environment_4;
