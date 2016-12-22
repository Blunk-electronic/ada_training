-- This is a simple ada program, that modifies an integer
-- via a function.

with ada.text_io; use ada.text_io;

procedure function_simple is

	n : integer := 1974;

	function add (in_a, in_b : integer) return integer is
		sum : integer;
	begin
		sum := in_a + in_b;
		return sum;
	end add;

begin
	put_line ("before :" & integer'image(n));
	n := add (in_a => n, in_b => 10);
	put_line ("after  :" & integer'image(n));
end function_simple;
