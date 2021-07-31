-- This is a simple ada program,
-- that demonstrates an ordinary fixed point type.
-- This type is also called "binary fixed point type".

with ada.text_io;	use ada.text_io;

procedure types_fixed_point_1 is

	step_width : constant := 0.5;
	type type_angle is delta step_width range 0.0 .. 359.5;
	
	angle : type_angle;
	
begin
	--put_line ("step width :" & type_angle'image (step_width));
	
	angle := type_angle'last; 
	put_line (type_angle'image (angle)); -- 359.5
	
	angle := type_angle'first;
	put_line (type_angle'image (angle));  -- 0.0
	
	angle := 0.1;
	put_line (type_angle'image (angle)); -- 0.0

	angle := 0.49;
	put_line (type_angle'image (angle)); -- 0.0

	angle := 0.5;
	put_line (type_angle'image (angle)); -- 0.5

	angle := 0.51;
	put_line (type_angle'image (angle)); -- 0.5

	angle := 0.99;
	put_line (type_angle'image (angle)); -- 0.5

	angle := 1.01;
	put_line (type_angle'image (angle)); -- 1.0

	angle := angle + 1.0;
	put_line (type_angle'image (angle)); -- 2.0
		
end types_fixed_point_1;
