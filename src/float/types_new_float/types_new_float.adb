-- This is a simple ada program,
-- that demonstrates a user specific 
-- new type float with a given precision.

with ada.text_io;	use ada.text_io;

procedure types_new_float is

	type kilogramms is digits 4 range 0.0 .. 11.0;
	mass : kilogramms := 0.2;

begin
	-- mass := 11.4; -- Causes a warning at compile and
					 -- a constraint error at run time.

	mass := 10.035;  -- rounding takes place

	put_line("the apple weights :" & kilogramms'image(mass) & " kg");

	mass := mass / 2.0; -- discards the last digit (5).
	put_line("the apple half weights :" & kilogramms'image(mass) & " kg");
end types_new_float;
