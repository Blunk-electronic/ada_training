-- This is a simple ada program, that
-- demonstrates a simple access type.

with ada.text_io;	use ada.text_io;

procedure types_access_2 is

	-- Declare two accesses to an integer:
	ai, bi : access integer;

begin
	-- Create an integer of value -10 where ai is pointing at:
	ai := new integer'(-10);
	bi := ai; -- backup address
	
	-- Create another integer of value 4 where ai is pointing at now:
	ai := new integer'(4);

	-- Display the value of the integer where ai is pointing at:
	put_line ( integer'image(ai.all) );

	ai := bi; -- restore address

	-- Display the value of the integer where ai is pointing at:
	put_line ( integer'image(ai.all) );
	
end types_access_2;
