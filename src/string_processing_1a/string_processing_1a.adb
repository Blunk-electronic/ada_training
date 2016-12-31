-- Here we demonstrate the 
-- processing of fixed strings.

with ada.text_io; use ada.text_io;
with ada.strings.fixed; use ada.strings.fixed;

procedure string_processing_1a is
	a : string (4..10) := "Ada2012";
	b : string (1..20) := (20 * '-');
begin
	put_line (positive'image(a'length));
	put_line (positive'image(a'first));
	put_line (positive'image(a'last));

	put_line (character'image(a(5)));
	a(9) := '2';

	put_line (3 * (a & ' '));

	put_line (b);

end string_processing_1a;
