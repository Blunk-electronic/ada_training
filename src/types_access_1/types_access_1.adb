-- This is a simple ada program, that
-- demonstrates a simple access type.

with ada.text_io;	use ada.text_io;

procedure types_access_1 is

	-- Declare an access to an integer:
	ai : access integer;

begin
	-- Create an integer of value -10 where ai is pointing at:
	ai := new integer'(-10);
	
	-- ai := new float'(1.5); -- does not compile

	-- Display the value of the integer where ai is pointing at:
	put_line ( integer'image(ai.all) );

end types_access_1;
