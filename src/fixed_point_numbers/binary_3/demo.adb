-- This is a simple ada program,
-- that demonstrates an issue with ordinary fixed point types.
-- This type is also called "binary fixed point type".

with ada.text_io;	use ada.text_io;

procedure demo is

	-- This requested step width is not a power of two:
	step_width : constant := 0.1;
	-- The nearest step width that is both:
	-- a power of two AND
	-- is less than or equal 0.1 
	-- is 0.0625.
	-- So a delta of actually 0.0625 applies for our fixed point type.
	
	type type_distance is delta step_width range 0.0 .. 100_000.0;

	-- This enforces the step width:
	-- for type_distance'small use step_width; 
	
	distance : type_distance := 0.0;

	d1, d2, d3 : type_distance := 0.0;
	
begin
	
--ISSUE 1---------------------------------------------------
	
	-- Each iteration of this loop adds 0.1 to the 
	-- distance. Naturally we would expect a final distance
	-- of 10,000.0 ...
	
	for i in 1 .. 100_000 loop
		distance := distance + step_width;		
	end loop;

	put_line (type_distance'image (distance));
	-- ... But we get 6,250 !!
	-- Why ? Due to the actual effective step width of 0.0625
	-- the result is 100,000 times 0.0625.
	
	-- Uncomment the statement in line 20 
	-- (after the type declaration) and try again.

--ISSUE 2---------------------------------------------------

	d1 := 1.02;
	d2 := 1.03;

	-- compute the average:
	d3 := (d1 + d2) / 2.0;
	-- We would expect 1.0025 ...
	
	put_line (type_distance'image (d3)); 
	-- ... but we get 1.02 !

	-- Try a step_width of 0.001 and try again.
	
end demo;
