-- This is a simple ada program,
-- that demonstrates how to round float types.

-- See discussion on http://computer-programming-forum.com/44-ada/b70b47aecd89c824.htm

with ada.text_io;	use ada.text_io;

procedure round is

	type type_float is digits 3;
	
	d : type_float;

	
	procedure do_it (
		f : in out type_float;	-- the number to be rounded
		a : in positive)		-- the accuracy, the number of decimal places	
	is 
		base : constant type_float := 10.0;
	begin
		put_line ("given   :" & type_float'image (f));
		put_line ("accuracy:" & positive'image (a));

		f := type_float'rounding (f * base**a) * base**(-a); 
		
		put_line ("rounded :" & type_float'image (f));
		new_line;
	end do_it;

	
begin
	
	
	d := 1.01;
	do_it (d, 1); -- 1.0

	d := 0.01;
	do_it (d, 1); -- 0.0

	
	d := 1.49;
	do_it (d, 1); -- 1.5

	d := 1.51;
	do_it (d, 1); -- 1.5

	d := 15.0;
	do_it (d, 1); -- no change

	
	
	--d := -4.33680868994201774E-19;
	--do_it (d, 17);
	
end round;
