-- This is a simple ada program, that
-- demonstrates how to copy objects
-- between records via access types.

with ada.text_io;	use ada.text_io;

procedure access_records_2 is

	type apple is record
		weight : float;
		size   : float;
		rotten : boolean;
	end record;

	-- Define two incompatibe access types to record type "apple"
	type ptr_a is access apple;
	type ptr_b is access apple;
	
	-- Allocate and initialize two apples accessed by pa and pb:
	pa : ptr_a := new apple'(weight => 0.23, size => 6.4, rotten => false);
	pb : ptr_b := new apple'(weight => 0.4, size => 5.9, rotten => true);
begin
	pa.all := pb.all; -- copy objects from pb to pa
	
	-- Display the weight of the apple accessed by pa:
	put_line ( float'image(pa.weight) );
	
end access_records_2;
