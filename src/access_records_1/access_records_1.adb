-- This is a simple ada program, that
-- demonstrates an access to a record type.

with ada.text_io;	use ada.text_io;

procedure access_records_1 is

	-- Define an apple:
	type apple is record
		weight : float;
		size   : float;
		rotten : boolean;
	end record;

	-- Define an access to record type "apple"
	type ptr is access apple;
	
	-- Allocate and initialize an apple accessed by pa:
	pa : ptr := new apple'(weight => 0.23, size => 6.4, rotten => false);
begin

	-- Display the weight of the apple accessed by pa:
	put_line ( float'image(pa.weight) );
	
end access_records_1;
