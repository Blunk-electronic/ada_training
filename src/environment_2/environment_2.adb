-- This is a simple ada program, that 
-- demonstrates command line arguments.

with ada.text_io; use ada.text_io;
with ada.command_line; use ada.command_line;

procedure environment_2 is

	i : integer;
	f : float;

begin
	-- i := argument(1); -- does not compile
	
	i := integer'value( argument(1) );
	put_line("argument 1: " & integer'image(i));
	
	f := float'value  ( argument(2) );
	put_line("argument 2: " & float'image(f));
	
end environment_2;
