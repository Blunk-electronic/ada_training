-- This is a simple ada program, that
-- demonstrates an access to a function type.

with ada.text_io;	use ada.text_io;

procedure access_functions_2 is

	-- Define an access to ANY function takes and returns an integer:
	type type_my_access is access function ( i : in integer) return integer;

	-- This is a simple function that doubles an integer:
	function double ( n : in integer ) return integer is begin
		return n * 2;
	end double;

	-- This is a simple function that squares an integer:
	function square ( n : in integer ) return integer is begin
		return n ** 2;
	end square;

	-- Instantiate an access of type type_my_access that refers to 
	-- function double.
	p : type_my_access := double'access;

begin
	-- Call function double via access p:
	put_line( integer'image( p(4) ) );

	-- Call function square via access p:
	p := square'access;
	put_line( integer'image( p(4) ) );	

end access_functions_2;
