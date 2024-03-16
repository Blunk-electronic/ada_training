-- This is a simple ada program,
-- that demonstrates a so called 
-- decimal fixed point type.

with ada.text_io;	use ada.text_io;

procedure demo is

	step_width : constant := 0.01;
	type type_distance is delta step_width digits 8 range 0.0 .. 100_000.00;
	
	distance : type_distance := 0.0;
	
begin
	-- Each iteration of this loop adds 0.01 to the distance.
	-- We expect an outcome of 1,000.00:
	
	for i in 1 .. 100_000 loop
		distance := distance + step_width;		
	end loop;

	put_line (type_distance'image (distance)); -- 1,000.00
	
end demo;
