-- This is a simple ada program, that
-- demonstrates an access to a procedure type.

with ada.text_io;	use ada.text_io;

procedure access_procedures_2 is

	-- Define an access to ANY procedure that "inouts" a number:
	type type_my_access is not null access procedure (n : in out integer);

	-- This is a procedure that doubles a number:
	procedure double (x : in out integer) is begin
		x := x * 2;
	end double;

	-- This is a procedure that squares a number:
	procedure square (y : in out integer) is begin
		y := y ** 2;
	end square;

	a : integer := 3;

	-- P "points" to procedure "double":
	p : type_my_access := double'access;

begin
	p(a);	put_line(integer'image(a)); -- result 6

	-- p "points" to procedure "square":
 	p := square'access; 
	p(a);	put_line(integer'image(a)); -- result 36

end access_procedures_2;
