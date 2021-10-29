-- This is a simple ada program,
-- that demonstrates a decimal fixed point types.

with ada.text_io;	use ada.text_io;

procedure types_fixed_point_4 is

	step_width : constant := 0.01;
	type type_distance is delta step_width digits 8 range 0.0 .. 100_000.00;
	
	distance : type_distance := 0.0;
	
begin
	-- Each iteration of this loop adds 0.01 to the distance.
	-- We expect an outcome of 1000.00:
	
	for i in 1 .. 100_000 loop
		distance := distance + 0.01;		
	end loop;

	put_line (type_distance'image (distance)); -- 1000.00
	
end types_fixed_point_4;
