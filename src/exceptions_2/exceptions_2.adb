-- This is a simple ada program, that
-- demonstrates a simple exception handler.

with ada.text_io; use ada.text_io;

procedure exceptions_2 is

	type array_of_integers is array (positive range 1..5) of integer;
	a : array_of_integers;
begin
	a(6) := 4; -- Assign non-existing member 6 the value 4.
	-- Causes a warning at compile time and
	-- a CONSTRAINT_ERROR at run time.
	-- Program control passed to exception handler.

	put_line("Everything fine."); -- skipped on exception

	-- Exception handler:
	exception
		when constraint_error =>
			put_line ("ERROR: Array index invalid !");

end exceptions_2;
