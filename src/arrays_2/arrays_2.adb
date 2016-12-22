-- This is a simple ada program, that
-- demonstrates an unconstrained array.

with ada.text_io; use ada.text_io;

procedure arrays_2 is
	-- define the array type
	type unconstrained_array is array (natural range <>) of integer;
	subtype constrained_array is unconstrained_array (1..5);

	-- instantiate an array and initalize all members with zero value
	a : constrained_array := (others => 0);
begin
	a(2) := 4; -- assign member 2 the value 4

	-- display all members of array a
	for i in constrained_array'first .. constrained_array'last loop
		put_line ("member" & positive'image(i) & " :" & integer'image(a(i)));
	end loop;
end arrays_2;
