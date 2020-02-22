with ada.text_io;			use ada.text_io;
with ada.command_line; 		use ada.command_line;

procedure rotation is

	type type_rotation is delta 1.0 range -270.0 .. 270.0;
	--for type_rotation'small use 1.0;
	for type_rotation'small use 0.1;

	start : constant type_rotation := type_rotation'value (argument (1));
	offset : constant type_rotation := 45.0 - type_rotation'small;
	step : constant type_rotation := 90.0;
		
	function to_string (r : in type_rotation) return string is begin
		return type_rotation'image (r);
	end;

	a : type_rotation := start;
	r1 : type_rotation;
	r2 : integer;

begin
	
	while a < type_rotation'last loop
		
		r1 := (a + offset) / 90.0;
		
		r2 := integer (r1);

		put_line (to_string (a) & " " & to_string (r1) & " " & integer'image (r2));

		a := a + step;
	end loop;
	
end rotation;
