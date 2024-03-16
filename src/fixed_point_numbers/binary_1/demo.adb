-- This is a simple ada program,
-- that demonstrates an ordinary fixed point type.
-- This type is also called "binary fixed point type"
-- because the distance between the numbers is always
-- a power of two.

with ada.text_io;	use ada.text_io;

procedure demo is

	-- This requested step width is exactly a power of two:
	-- step_width : constant := 0.5;

	-- But this requested step width is not a power of two:
	step_width : constant := 1.0 / 3.0; -- 0.333
	-- The nearest available step width that is both:
	-- a power of two AND
	-- is less than or equal 0.333 
	-- is 0.25.
	-- So a delta of actually 0.25 applies for our fixed point type.
	
	type type_angle is delta step_width range -359.5 .. 359.5;
	
	angle : type_angle;
	
begin
	--put_line ("step width :" & type_angle'image (step_width));
	
	-- angle := type_angle'last; 
	-- put_line (type_angle'image (angle)); -- 359.5
	
	angle := type_angle'first;
	put_line (type_angle'image (angle));  -- 0.0 / 0.0
	
	angle := 0.1;
	put_line (type_angle'image (angle)); -- 0.0 / 0.0

	angle := 0.49;
	put_line (type_angle'image (angle)); -- 0.0 / 0.3

	angle := 0.5;
	put_line (type_angle'image (angle)); -- 0.5 / 0.5

	angle := 0.51;
	put_line (type_angle'image (angle)); -- 0.5 / 0.5

	angle := 0.99;
	put_line (type_angle'image (angle)); -- 0.5 / 0.8

	angle := -0.99;
	put_line (type_angle'image (angle)); -- -0.5 / -0.8
	
	angle := 1.01;
	put_line (type_angle'image (angle)); -- 1.0 / 1.0

	-- angle := angle + 1.0;
	-- put_line (type_angle'image (angle)); -- 2.0
		
end demo;
