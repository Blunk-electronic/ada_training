with ada.text_io;			use ada.text_io;
with ada.command_line; 		use ada.command_line;

procedure rotation is

	type type_rotation is delta 1.0 range -270.0 .. 270.0;
	for type_rotation'small use 0.1;

	start : constant type_rotation := type_rotation'value (argument (1));
	stop  : constant type_rotation := type_rotation'value (argument (2));
	step  : constant type_rotation := type_rotation'value (argument (3));
		
	function to_string (r : in type_rotation) return string is begin
		return type_rotation'image (r);
	end;

	type type_orientation is (HORIZONTAL, VERTICAL);

	function to_string (r : in integer) return string is begin
		if r rem 2 = 0 then
			return type_orientation'image (HORIZONTAL);
		else 
			return type_orientation'image (VERTICAL);
		end if;
	end;
		
	offset : constant type_rotation := 45.0 - type_rotation'small;
	
	a : type_rotation := start;
	r1 : type_rotation;
	r2 : float;
	r3 : integer;

begin
	
	while a < stop loop
		
		r1 := (abs (a) + offset) / 90.0;
		
		r2 := float'floor (float (r1));
		r3 := integer (r2);

-- 		put_line (to_string (a) & " "
-- 			& to_string (r1) & " " 
-- 			& integer'image (r3) & " "
-- 			& to_string (r3));

		put_line (to_string (a) & " "
-- 			& to_string (r1) & " " 
-- 			& integer'image (r3) & " "
			& to_string (r3));
		
		a := a + step;
	end loop;
	
end rotation;
