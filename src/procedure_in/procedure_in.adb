-- This is a simple ada program, that outputs "hello Ada !"
-- via a procedure with input parameter on the terminal.

with ada.text_io; use ada.text_io;

procedure procedure_in is

	procedure output_text (text : in string) is
	begin
		put_line (text);
	end output_text;

begin
	output_text ("hello Ada !");
end procedure_in;
