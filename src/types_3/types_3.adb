-- This is a simple ada program,
-- demonstrates some predefined data types.

with ada.text_io;	use ada.text_io;

procedure types_3 is
	c		: character	:= 'A';
	d		: duration	:= 1.0; -- seconds
begin
	for i in 1..5 loop
		put(character'image(c) & " ");
		delay d;
	end loop;
	new_line;
end types_3;
