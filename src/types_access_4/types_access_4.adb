-- This is a simple ada program, that
-- demonstrates how to copy objects
-- accessed by access types.

with ada.text_io;	use ada.text_io;

procedure types_access_4 is

	-- Create two different incompatible named access types:
	type ptr_a is access integer;
	type ptr_b is access integer;	

	-- Declare two different accesses to an integer:
	ai : ptr_a;
	bi : ptr_b;

begin
	-- Create integer #1 of value -10 where ai is pointing at:
	ai := new integer'(-10);
	-- Create integer #2 of value -20 where ai is pointing at:
	bi := new integer'(-20);
	
	-- Overwrite integer #1 with integer #2 (copy):
	ai.all := bi.all; 

	-- Display the value of the integer where ai is pointing at:
	put_line ( integer'image(ai.all) );
	
end types_access_4;
