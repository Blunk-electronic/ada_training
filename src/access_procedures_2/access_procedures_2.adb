-- This is a simple ada program, that
-- demonstrates an access to a procedure type.

with ada.text_io;	use ada.text_io;

procedure access_procedures_2 is

	-- Define an access to ANY procedure that "inouts" a number:
	type type_my_access is not null access procedure (n : in out integer);

	procedure double (x : in out integer) is begin
		x := x * 2;
	end double;

	procedure square (y : in out integer) is begin
		y := y ** 2;
	end square;

	a : integer := 3;
	p : type_my_access := double'access;

begin

	p(a);	put_line(integer'image(a));
 	p := square'access;
	p(a);	put_line(integer'image(a));

end access_procedures_2;
