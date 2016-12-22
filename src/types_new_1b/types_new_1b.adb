-- This is a simple ada program,
-- that demonstrates user specific 
-- new types.

with ada.text_io;	use ada.text_io;

procedure types_new_1b is

	-- This is a new created types with
	-- its subtype:
	type parking_lots is range 1..20;
	subtype cars is parking_lots range 1..20;

	c : cars := 19;

begin
	c := c + 1;
	put_line("cars:" & cars'image(c));
	
	c := c + 1; -- causes a warning and constraint error at run time
	
end types_new_1b;
