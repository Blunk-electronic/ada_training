-- This is a simple ada program, that
-- demonstrates a record.

with ada.text_io; use ada.text_io;

procedure records_1 is

	type type_color is (red, green, yellow);

	-- define an apple
	type type_apple is
		record
			color		: type_color;
			weight		: float;
			rotten		: boolean := false;
		end record;

	-- instantiate an apple
	apple : type_apple;
begin
	apple.color := yellow;
	apple.weight := 230.4; -- gramms

	put_line ("the apple has color " & type_color'image(apple.color));

end records_1;
