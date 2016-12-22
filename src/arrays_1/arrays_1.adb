-- This is a simple ada program, that
-- demonstrates a constrained array.

with ada.text_io; use ada.text_io;

procedure arrays_1 is
	-- define the array type
	type array_of_integers is array (positive range 1..5) of integer;

	-- instantiate an array and initalize all members with zero value
	a : array_of_integers := (others => 0);
begin
	a(2) := 4; -- assign member 2 the value 4

	-- display all members of array a
	for i in array_of_integers'first .. array_of_integers'last loop
		put_line ("member" & positive'image(i) & " :" & integer'image(a(i)));
	end loop;
end arrays_1;
