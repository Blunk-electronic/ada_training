-- Here we demonstrate the usage of
-- unbounded strings.

with ada.text_io;           use ada.text_io;
with ada.strings.unbounded; use ada.strings.unbounded;

procedure string_processing_3 is

	a : string (1..3) := "Ada";
	b : unbounded_string := to_unbounded_string("2005");

begin

 	b := to_unbounded_string("95");
 	put_line (a & " " & to_string(b));

 	b := to_unbounded_string("2012");
 	put_line (a & " " & to_string(b));

end string_processing_3;
