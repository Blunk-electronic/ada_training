-- This is a simple ada program,
-- that demonstrates user specific 
-- new types.

with ada.text_io;	use ada.text_io;

procedure types_new_3 is

	type colors is (red, green, blue);

begin
	put_line ( colors'image ( green) );
	
	for c in 0..colors'pos( colors'last ) loop
		put_line( colors'image( colors'val(c) ) & " ");
	end loop;

end types_new_3;