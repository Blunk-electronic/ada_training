-- This is a simple ada program,
-- that demonstrates an issue with ordinary fixed point types.
-- This type is also called "binary fixed point type".

with ada.text_io;	use ada.text_io;

procedure types_fixed_point_3 is

	step_width : constant := 0.01;
	type type_distance is delta step_width range 0.0 .. 100_000.0;
	for type_distance'small use step_width; 
	
	distance : type_distance := 0.0;

	d1, d2, d3 : type_distance := 0.0;
	
begin
--ISSUE 1---------------------------------------------------
	
	-- Each iteration of this loop adds 0.01 to the 
	-- distance. Naturally we would expect a final distance
	-- of 1000.0 ...
	
	for i in 1 .. 100_000 loop
		distance := distance + 0.01;		
	end loop;

	put_line (type_distance'image (distance));
	-- ... But we get 781.25 !!
	-- Why ? Due to the way a float number is represented
	-- internally, there is a small error.
	-- This small error adds up in each iteration so 
	-- that the total error gets even more.
	
	-- Uncomment the line right after the type declaration
	-- and try again.

--ISSUE 2---------------------------------------------------

	d1 := 1.02;
	d2 := 1.03;

	-- compute the average:
	d3 := (d1 + d2) / 2.0;
	-- We would expect 1.0025 ...
	
	put_line (type_distance'image (d3)); 
	-- ... but we get 1.02 !

	-- Try a step_width of 0.001 and try again.
	
end types_fixed_point_3;
