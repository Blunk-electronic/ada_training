-- This is a simple ada program, that
-- demonstrates the purpose of a 
-- not-null-access type.

with ada.text_io;	use ada.text_io;

procedure types_access_6 is

	type ptr_a is not null access integer;
	type ptr_b is not null access integer;	

	-- ai : ptr_a; -- Causes a warning at compile and a
				-- constraint error at run time.
	
	-- Allocate and initialize integer #1 accessed by ai:
	ai : ptr_a := new integer'(-10);
	-- Allocate and initialize integer #2 accessed by bi:
	bi : ptr_b := new integer'(-20);
begin
	-- Overwrite integer #1 with integer #2
	ai.all := bi.all;

	-- Display the value of the integer where ai is pointing at:
	put_line ( integer'image(ai.all) );
	
end types_access_6;
