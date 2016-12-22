-- This is a simple ada program, that modifies an integer
-- via a procedure with output parameter.

with ada.text_io; use ada.text_io;

procedure procedure_out is

	n : integer := 1974;

	procedure modify (n : out integer) is
	begin
		n := 1980;
	end modify;

begin
	put_line ("before :" & integer'image(n));
	modify(n);
	put_line ("after  :" & integer'image(n));
end procedure_out;
