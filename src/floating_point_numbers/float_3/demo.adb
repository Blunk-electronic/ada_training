-- This is a simple ada program,
-- that demonstrates an issue with float types.

with ada.text_io;	use ada.text_io;

procedure demo is

	distance : float := 0.0;
	
begin
	-- Each iteration of this loop adds 0.01 to the 
	-- distance. Naturally we would expect a final distance
	-- of 1000.0 ...

	for i in 1 .. 100_000 loop
		distance := distance + 0.01;		
	end loop;

	put_line (float'image (distance));
	-- ... But we get 1000.67 !!
	-- Why ? Due to the way a float number is represented
	-- internally, there is a small error.
	-- This small error adds up in each iteration so 
	-- that the total error gets even more.
	
end demo;
