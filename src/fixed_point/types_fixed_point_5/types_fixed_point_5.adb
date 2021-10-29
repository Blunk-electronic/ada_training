-- This is a simple ada program,
-- that demonstrates an issue with decimal fixed point types.

with ada.text_io;	use ada.text_io;

procedure types_fixed_point_5 is

	step_width : constant := 0.01;
	type type_distance is delta step_width digits 8 range 0.0 .. 100_000.00;

	--step_width : constant := 0.001;
	--type type_distance is delta step_width digits 9 range 0.0 .. 100_000.00;

	
	d1, d2, d3 : type_distance := 0.0;
	
begin

	-- d2 := 0.005; -- does not compile
	

	d1 := 1.02;
	d2 := 1.03;

	-- compute the average:
	d3 := (d1 + d2) / 2.0;
	-- We would expect 1.025 ...
	
	put_line (type_distance'image (d3)); 
	-- ... but we get 1.02 !
	
end types_fixed_point_5;
