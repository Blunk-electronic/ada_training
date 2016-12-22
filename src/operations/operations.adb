-- This simple ada program demonstrates simple operations
-- on strings and numbers.

with ada.text_io;	use ada.text_io;

procedure operations is

	t1 : string (1..5) := "hello";
	t2 : string (1..3) := "Ada";

	n1 : integer := 10;
	n2 : integer := 20;
begin
	put_line (t1 & '_' & t2 & " !!");
	put_line ("The sum is" & integer'image(n2 + n1));
	put_line ("The difference is " & integer'image(n2 - n1));
	put_line ("The product is" & integer'image(n2 * n1));
	put_line ("The quotient is" & integer'image(n2 / n1));
end operations;
