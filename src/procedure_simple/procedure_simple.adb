-- This is a simple ada program, that outputs "hello world !"
-- via a procedure on the terminal.

with ada.text_io; use ada.text_io;

procedure procedure_simple is

	procedure output_text is
	begin
		put_line ("hello Ada !");
	end output_text;

begin
	output_text;
end procedure_simple;
