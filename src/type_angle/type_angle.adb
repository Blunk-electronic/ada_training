-- This is a simple ada program,
-- demonstrates some data types.


pragma assertion_policy (check);
with system.assertions;
with ada.text_io;	use ada.text_io;

procedure type_angle is

	angle_delta : constant := 5;

	subtype angle is integer range -355 .. 355
	with dynamic_predicate => angle mod angle_delta = 0;
	a : angle;
	
begin
	a := -355;
	a :=  355;
	-- a := 360; -- warning at compile time, error at runtime -> ok
	a := 0;
	a := 5;
	
	a := 7; -- no error at compile time -> would be good to get an error here

	--a := a + 2; -- error at runtime -> ok

	exception 
		when constraint_error => 
			put_line ("outside range");

		when system.assertions.assert_failure =>
			put_line ("invalid step width ! Step width must be" & integer'image (angle_delta));

		when others =>
			put_line ("other error");
			
end type_angle;
