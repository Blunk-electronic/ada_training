-- This is a simple ada program,
-- that demonstrates user specific 
-- new types.

with ada.text_io;	use ada.text_io;

procedure types_new_1 is

	-- These are new created types which are
	-- not compatible even if they have the same range:
	type parking_lots is range 1..20;
	type cars is range 1..20;

	p : parking_lots := 11;
	c : cars := 3;

begin
	p := p - 1;
	put_line("parking lots:" & parking_lots'image(p));

	-- c := c + p; -- does not compile
	put_line("cars:" & cars'image(c));
end types_new_1;
