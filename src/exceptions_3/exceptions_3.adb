-- This is a simple ada program, that
-- demonstrates how an exception occurs.

with ada.text_io; use ada.text_io;

procedure exceptions_3 is

	p, q, r : natural := 0;
begin
	r := p / q; -- Division by zero.
	-- Causes a warning at compile time and
	-- a CONSTRAINT_ERROR at run time.
	-- Program control passed to exception handler.

	put_line("Everything fine."); -- skipped on exception

	-- Exception handler:
	exception
		when constraint_error =>
			put_line ("ERROR: Division by zero !");

end exceptions_3;
