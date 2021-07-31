-- This is a simple ada program,
-- that demonstrates an ordinary fixed point type.
-- This type is also called "binary fixed point type".

with ada.text_io;	use ada.text_io;

procedure types_fixed_point_2 is

	step_width : constant := 0.5;
	type type_angle is delta step_width range 0.0 .. 359.5;
	--for type_angle'small use step_width;
	
	angle : type_angle;
	
begin
	--put_line ("step width :" & type_angle'image (step_width));
	
	angle := 10.0;
	put_line (type_angle'image (angle)); -- 10.0

	angle := angle / 4.0;
	put_line (type_angle'image (angle)); -- 2.5

	angle := angle * 4.0;
	put_line (type_angle'image (angle)); -- 10.0
	
	--angle := angle / 3.0;
	--put_line (type_angle'image (angle)); -- 3.0 (instead of 3.33)

	--angle := angle * 3.0;
	--put_line (type_angle'image (angle)); -- 9.0 (instead of 9.99)
		
end types_fixed_point_2;
