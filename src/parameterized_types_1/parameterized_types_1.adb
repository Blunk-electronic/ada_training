-- Here we demonstrate a simple parameterized type.

with ada.text_io; use ada.text_io;
with ada.strings.unbounded; use ada.strings.unbounded;

procedure parameterized_types_1 is

	type type_car ( seat_count : positive) is
		record
			manufacturer : unbounded_string;
			door_count   : positive;
		end record;

	c : type_car( seat_count => 5 );
begin
	c.manufacturer := to_unbounded_string("Vauxhall");
	c.door_count := 3;

	-- c.seat_count := 4; -- does not compile
	put_line (to_string( c.manufacturer) );
end parameterized_types_1;
