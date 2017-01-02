-- Here we demonstrate conversion
-- between types of strings.

with ada.text_io;         use ada.text_io;
with ada.strings.bounded; use ada.strings.bounded;
with ada.strings.unbounded; use ada.strings.unbounded;

procedure string_processing_4 is

	package type_us1 is new generic_bounded_length(20); use type_us1;
 	package type_us2 is new generic_bounded_length(10); use type_us2;

	f  : string (1..3) := "Ada";
	b1 : type_us1.bounded_string := to_bounded_string("2005");
	b2 : type_us2.bounded_string := to_bounded_string("2012");
	u  : unbounded_string := to_unbounded_string("95");
begin

	b1 := f & b1;
	-- b1 := b2; -- does not compile
	b1 := to_bounded_string( to_string(b2) );
	put_line (to_string(b1));

	-- u := b1; -- does not compile
	u := to_unbounded_string( to_string(b1) );
	put_line (to_string(u));

end string_processing_4;
