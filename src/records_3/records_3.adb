-- This is a simple ada program, that
-- demonstrates a null-record.

with ada.text_io; use ada.text_io;

procedure records_3 is

	type type_useless_record is null record;
	
	type type_dummy is tagged null record;

	type type_useless_dummy is new type_dummy with null record;
	
	type type_apple is new type_dummy with record
		weight		: float;
		rotten		: boolean := false;
	end record;

	useless_apple : type_useless_dummy;
	
	apple : type_apple;

	
begin
	apple.weight := 230.4; -- gramms
end records_3;
