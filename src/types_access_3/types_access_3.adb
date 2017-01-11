-- This is a simple ada program, that
-- demonstrates a simple access type.

with ada.text_io;	use ada.text_io;

procedure types_access_3 is

	-- Create two different named access types:
	type ptr_a is access integer;
	type ptr_b is access integer;	

	-- Declare two different accesses to an integer:
	ai : ptr_a;
	bi : ptr_b; -- try ptr_a ?

begin
	-- Create integer #1 of value -10 where ai is pointing at:
	ai := new integer'(-10);
	-- Create integer #2 of value -20 where ai is pointing at:
	ai := new integer'(-20);
	-- Change integer #2 to value -21
	ai.all := -21; 
	
	-- bi := ai; -- does not compile

	-- Display the value of the integer where ai is pointing at:
	put_line ( integer'image(ai.all) );
	
end types_access_3;
