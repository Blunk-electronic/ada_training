-- This is a simple ada program,
-- that demonstrates default values.

with ada.text_io;	use ada.text_io;

procedure defaults_1 is

	n : natural; -- compile warning
	f : float;   -- compile warning

	type coordinates is record
		x, y : float;
	end record;

	c : coordinates; -- compile warning

	type coordinates_with_default is record
		x, y : float := 0.0;
	end record;

	d : coordinates_with_default;

-- 	type coordinates_with_incomplete_default is record
-- 		x : float := 0.0;
-- 		y : float;
-- 	end record;
-- 
-- 	e : coordinates_with_incomplete_default;
	
begin
	-- We get arbitrary values here:
	put_line ("n:  " & natural'image (n));
	put_line ("f:  " & float'image (f));

	put_line ("c.x " & float'image (c.x));
	put_line ("c.y " & float'image (c.y));

	-- These are well defined because they have a default:
	put_line ("d.x " & float'image (d.x));
	put_line ("d.y " & float'image (d.y));

	d.x := 1.0;
	d.y := 2.4;

	-- Restore default values:
	d := (others => <>);

	put_line ("d.x " & float'image (d.x));
	put_line ("d.y " & float'image (d.y));

end defaults_1;
