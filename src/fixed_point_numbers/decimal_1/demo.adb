-- This is a simple ada program,
-- that does a simple performance text with
-- decimal fixed point numbers.
-- This type is suitable for commercial applications.

-- To see the elapsed time launch the executable 
-- with the bash command:
-- time ./demo

with ada.text_io;	use ada.text_io;

procedure demo is

	step_width : constant := 0.1;

	end_of_range : constant := 100_000_000.0;
	type type_money is delta step_width digits 10 
		range 0.0 .. end_of_range;
	
	money : type_money := 0.0;
	
begin
	-- Each iteration of this loop adds 0.1 cent to money.
	
	-- for i in 1 .. 100_000 loop
	while money < end_of_range loop
		money := money + step_width;		
	end loop;

	put_line (type_money'image (money));
	
end demo;
