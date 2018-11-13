-- This is a simple ada program,
-- that demonstrates fixed point types.

with ada.text_io;	use ada.text_io;

procedure types_fixed_point_1 is

	step_width : constant := 0.01;
	type type_angle is delta step_width range 0.0 .. 359.99;
	for type_angle'small use step_width;
	
	angle : type_angle;
	
begin
	put_line ("step width :" & type_angle'image (step_width));
	
	angle := type_angle'last; -- 359.99
	angle := type_angle'first; -- 0.00

	for i in 1..10 loop
		
		angle := angle + type_angle'small;
		put_line ("angle :" & type_angle'image (angle));
		
	end loop;
		
end types_fixed_point_1;
