-- This is a simple ada program,
-- demonstrates some data types.

with ada.text_io;	use ada.text_io;

procedure types_2 is
	i		: integer  	:= -5;
	n		: natural	:= 0;
	f		: float		:= 4.5;
begin
	i := i + n; -- compiles

	n := n + i; -- compiles with warning, 
				-- but raises constraint error at run time

	f := f + i; -- does not compile
end types_2;
