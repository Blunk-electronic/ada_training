-- This is a simple ada program, that
-- demonstrates the need of a 
-- not-null-access type.

with ada.text_io;	use ada.text_io;

procedure types_access_5 is

	type ptr_a is access integer;
	type ptr_b is access integer;	

	ai : ptr_a;   bi : ptr_b; -- Both point nowhere ! Like default:
--	ai : ptr_a := null;   
--	bi : ptr_b := null;
begin
	-- Create integer #1 of value -10 where ai is pointing at:
	ai := new integer'(-10);
	
	ai.all := bi.all; -- Causes warning at compile and 
					-- constraint error at run time.

	-- Display the value of the integer where ai is pointing at:
	put_line ( integer'image(ai.all) );
	
end types_access_5;
