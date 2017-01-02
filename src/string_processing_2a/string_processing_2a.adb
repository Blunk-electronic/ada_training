-- Here we demonstrate the 
-- processing of bounded strings.

with ada.text_io; use ada.text_io;
with ada.strings.bounded; use ada.strings.bounded;

procedure string_processing_2a is

 	package type_universal_string is new generic_bounded_length(100); 
	use type_universal_string;
	
	a : type_universal_string.bounded_string := to_bounded_string("Ada2012");

begin
	put_line (positive'image(length(a)));
	put_line (character'image( element(a,1)) );
	put_line (character'image( element(a, length(a)) ) );
	replace_element ( a, 6, '3' );
	put_line (slice (a, 4, 7 ));
	put_line (type_universal_string.to_string(a));

	replace_slice (a, 4, 7, "83" );
	put_line (type_universal_string.to_string(a));
	put_line (natural'image( index(a, "83")) );

end string_processing_2a;
