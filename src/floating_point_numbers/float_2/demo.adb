-- This is a simple ada program,
-- that demonstrates the standard float type.

with ada.text_io;	use ada.text_io;

procedure demo is

	angle : float := 10.0;
	
begin
	put_line (float'image (angle));	-- 1.00000E+01

	angle := angle / 3.0;
	put_line (float'image (angle)); -- 3.33333E+00
	
	angle := angle * 3.0;
	put_line (float'image (angle));	-- 1.00000E+01

end demo;
