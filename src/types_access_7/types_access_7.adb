-- This is a simple ada program, that
-- demonstrates the how to manipulate
-- declared objects by a general access type.

with ada.text_io;	use ada.text_io;

procedure types_access_7 is

	-- Declare and initialize an aliased integer i:
	i : aliased integer := 10;

	-- Define a general access to an integer type:
	type ptr is access all integer;
	p : ptr;

begin
	put_line ( integer'image (i) ); -- i before manipulation

	p := i'access; -- p assumes address of i

	p.all := 20; -- assign new value where p points at

	put_line ( integer'image (i) ); -- i after manipulation

	-- put_line ( integer'image (p.all) ); -- i displayed by reference
	
end types_access_7;
