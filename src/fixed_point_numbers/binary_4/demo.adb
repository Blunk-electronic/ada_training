-- This is a simple ada program,
-- that does a simple performance text with
-- binary fixed point numbers.

-- To see the elapsed time launch the executable 
-- with the bash command:
-- time ./demo

with ada.text_io;	use ada.text_io;

procedure demo is

	step_width : constant := 0.1;
	
	end_of_range : constant := 100_000_000.0;

	type type_distance is delta step_width range 0.0 .. end_of_range;

	for type_distance'small use step_width; 

	
	distance : type_distance := 0.0;

	d1, d2, d3 : type_distance := 0.0;
	
begin

	while distance < end_of_range loop
		distance := distance + step_width;		
	end loop;

	put_line (type_distance'image (distance));
	
end demo;
