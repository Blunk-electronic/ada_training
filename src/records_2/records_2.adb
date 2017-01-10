-- This is a simple ada program, that
-- demonstrates a limited record.

with ada.text_io; use ada.text_io;

procedure records_2 is

	type type_color is (red, green, yellow);

	-- define a limited apple
	type type_apple is limited
		record
			color		: type_color;
			weight		: float;
			rotten		: boolean := false;
		end record;

	-- instantiate two apples
	apple_a, apple_b : type_apple;

begin
	apple_a.rotten := true;
	
	-- make a copy of apple_a
	-- apple_b := apple_a; -- does not compile

end records_2;
