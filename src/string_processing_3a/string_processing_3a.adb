-- Here we demonstrate the 
-- processing of unbounded strings.

with ada.text_io; use ada.text_io;
with ada.strings.unbounded; use ada.strings.unbounded;

procedure string_processing_3a is

	a : unbounded_string := to_unbounded_string("Ada2012");

begin
	put_line (positive'image(length(a)));
	put_line (character'image( element(a,1)) );
	put_line (character'image( element(a, length(a)) ) );
	replace_element ( a, 6, '3' );
	put_line (slice (a, 4, 7 ));
	put_line (to_string(a));

	replace_slice (a, 4, 7, "83" );
	put_line (to_string(a));
	put_line (natural'image( index(a, "83")) );

end string_processing_3a;
