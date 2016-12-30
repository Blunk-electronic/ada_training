-- Here we demonstrate the usage of
-- bounded strings.

with ada.text_io;         use ada.text_io;
with ada.strings.bounded; use ada.strings.bounded;

procedure string_processing_2 is

 	package type_universal_string is new generic_bounded_length(100); 
	use type_universal_string;

	a : string (1..3) := "Ada";
	b : type_universal_string.bounded_string := to_bounded_string("2005");

begin

	b := to_bounded_string("95");
	put_line (a & " " & to_string(b));

	b := to_bounded_string("2012");
	put_line (a & " " & to_string(b));

end string_processing_2;
