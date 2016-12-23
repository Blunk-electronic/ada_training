-- This is a simple ada program,
-- that demonstrates conversion
-- between numeric types.

with ada.text_io;	use ada.text_io;

procedure type_conversion_2 is

	type parking_lots is range 1..20;
	type cars is range 1..20;

	p : parking_lots := 20;
	c : cars := 3;

begin

	-- p := p - c; -- does not compile

	p := p - parking_lots(c);

	put_line("parking lots left:" & parking_lots'image(p));

end type_conversion_2;
