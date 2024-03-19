-- This is a simple ada program,
-- that does a simple performance text with
-- float numbers.

with ada.text_io;	use ada.text_io;

procedure demo is

	end_of_range : constant := 100_000_000.0;
	
	type my_float is digits 10 range 0.0 .. end_of_range;
	
	distance : my_float := 0.0;
	
begin

	while distance < end_of_range - 1.0 loop
		-- put_line (my_float'image (distance));
		distance := distance + 0.1;
	end loop;

	put_line (my_float'image (distance));

	-- Ends with:
	--
	-- 9.999999905E+07
	-- 99_999_999.05
	
end demo;

