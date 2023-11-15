-- This is a simple ada program,
-- that demonstrates how to customize
-- float types.

with ada.text_io;	use ada.text_io;

procedure types_float is

	f0 : float := 5.5; 	-- accuracy machine depended
						-- you get any accuracy
						-- probably too much accuracy

	f0n : float := -7.5;
	
	-- well defined accuracy
	type float_1 is digits 2;	
	f1 : float_1 := 5.5;

	-- well defined range
	type float_2 is digits 2 range 0.0 .. 2.0;
	f2 : float_2 := 1.1;
	
begin

	put_line (float'image (f0));					--  5.50000E+00
	put_line (float'image (float'floor (f0)));		--  5.00000E+00
	put_line (float'image (float'ceiling (f0)));	--  6.00000E+00
	new_line;
	
	put_line (float'image (f0n));					-- -7.50000E+00
	put_line (float'image (float'floor (f0n)));		-- -8.00000E+00
	put_line (float'image (float'ceiling (f0n)));	-- -7.00000E+00
	new_line;
	
	put_line (float_1'image (f1));	-- 5.5E+00
	put_line (float_2'image (f2));	-- 1.1E+00
	
end types_float;
