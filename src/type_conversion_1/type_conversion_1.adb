-- This is a simple ada program that
-- demonstrates conversion between
-- derived types.

with ada.text_io;	use ada.text_io;

procedure type_conversion_1 is

	type kilometers is new float range 0.0 .. 10.0;
	type miles is new float range 0.0 .. 10.0;

	k : kilometers;
	m : miles := 2.0;

begin
	-- k := 1.61 * m; -- does not compile
	k := 1.61 * kilometers(m);
	put_line("kilometers :" & kilometers'image(k));

end type_conversion_1;
