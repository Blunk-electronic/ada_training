-- This is a simple ada program,
-- demonstrates some data types.

pragma assertion_policy (check);
with ada.text_io;	use ada.text_io;

procedure type_angle is
	subtype angle is integer range -355 .. 355
	with dynamic_predicate => angle mod 5 = 0;
	a : angle;
begin
	a := -355;
	a :=  355;
	-- a := 360; -- warning at compile time, error at runtime -> ok
	a := 0;
	a := 5;
	
	-- a := 7; -- error at compile time -> ok

	a := a + 2; -- error at runtime -> ok

	exception 
		when constraint_error => 
			put_line ("outside range");

		--when SYSTEM.ASSERTIONS.ASSERT_FAILURE => -- ?
		when others =>
			put_line ("invalid step width ! Step width must be " & "5"); -- ?

end type_angle;
