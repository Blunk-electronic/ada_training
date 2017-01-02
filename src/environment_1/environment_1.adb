-- This is a simple ada program, that 
-- demonstrates command line arguments.

with ada.text_io; use ada.text_io;
with ada.command_line; use ada.command_line;

procedure environment_1 is

begin
	put_line ("argument count: " & natural'image(argument_count) );
	put_line ("command: " & command_name);	

	if argument_count > 0 then
		for a in 1..argument_count loop
			put_line ( argument(a) );
		end loop;
	end if;
end environment_1;
