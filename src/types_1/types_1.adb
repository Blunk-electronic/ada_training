-- This is a simple ada program,
-- demonstrates some data types.

with ada.text_io;	use ada.text_io;

procedure types_1 is
	text	: string (1..3) := "Ada";
	i		: integer  	:= -5;	-- -4,-1,0,1,5,107
	n		: natural	:= 0;  	-- 0,2,55,107
	p		: positive 	:= 4; 	-- 1,2,55,107
	f		: float 	:= 4.5E-04; --4.5, -7.561
	b		: boolean	:= false;
begin
	put_line (text);
	put_line (integer'image(i));
	put_line (natural'image(n));
	put_line (positive'image(p));
	put_line (float'image(f));
	put_line (boolean'image(b));
end types_1;
