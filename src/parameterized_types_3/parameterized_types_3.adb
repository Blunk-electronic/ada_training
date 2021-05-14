-- Here we demonstrate a simple parameterized type
-- with a default discriminant.

with ada.text_io; use ada.text_io;
with ada.strings.unbounded; use ada.strings.unbounded;

procedure parameterized_types_3 is

	-- The type can mutate later because it has 
	-- a default discriminant:
	type type_car (seat_count : positive := 5) is
		record
			manufacturer : unbounded_string;
			door_count   : positive;
		end record;

	c1 : type_car; -- assumes 5 seats by default

	c2 : type_car := (
			seat_count		=> 9, -- overrides default
			manufacturer	=> to_unbounded_string ("Ford"),
			door_count		=> 4);
	
begin
	
	c1.manufacturer := to_unbounded_string ("Vauxhall");
	c1.door_count := 3;

	-- The discriminant of c1 can not be changed this way:
	-- c1.seat_count := 3; -- does not compile

	-- A complete record assignment is required instead.
	-- Now c1 mutates to a car with 3 seats:
	c1 := (
		seat_count		=> 3,
		manufacturer	=> to_unbounded_string ("Opel"),
		door_count		=> 2);

	--c1 := (
		--seat_count		=> 10,
		--manufacturer	=> to_unbounded_string ("Opel"),
		--door_count		=> 2);
	
	put_line ("brand: " & to_string (c1.manufacturer));
	put_line ("seats:"  & positive'image (c1.seat_count));
	put_line ("doors:"  & positive'image (c1.door_count));



	new_line;
	
	-- The discriminant of c2 can not be changed this way:
	-- c2.seat_count := 10; -- does not compile

	-- A complete record assignment is required instead:
	c2 := (
		seat_count		=> 10,
		manufacturer	=> to_unbounded_string ("Ford"),
		door_count		=> 4);
	
	put_line ("brand: " & to_string (c2.manufacturer));
	put_line ("seats:"  & positive'image (c2.seat_count));
	put_line ("doors:"  & positive'image (c2.door_count));


	
end parameterized_types_3;
