-- This is a simple ada program,
-- demonstrates some data types.

-- with ada.text_io;	use ada.text_io;

procedure type_angle is
	Number_Small : constant := 5.0;
	type Number is delta Number_Small range -100.0 .. 100.0;
	for Number'Small use Number_Small;

	angle : number := 101.0;
begin
	-- no warning and no error at runtime:
	angle := 101.0; -- expect an error at compile time

	-- warning at compile time and constraint error at runtime:
	angle := 110.0; -- expect an error at compile time
end type_angle;
