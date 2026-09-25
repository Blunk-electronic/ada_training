-- This is a simple ada program, that
-- demonstrates updating an element via
-- a user definded subprogram.

--
-- For correct displaying set tab width in your editor to 4.
--
--
with ada.text_io;			use ada.text_io;
-- with ada.strings.unbounded;	use ada.strings.unbounded;
with ada.containers;		use ada.containers;
with ada.containers.doubly_linked_lists;


procedure demo is

	type type_color is (WHITE, BLUE, RED, GREEN);
	
	type type_car is record
		seats : positive := 2;
		color : type_color := WHITE;
	end record;


	package pac_cars is new doubly_linked_lists (type_car);
	use pac_cars;

	-- The collection of cars:
	cars : pac_cars.list;


	procedure show_car (
		c : in pac_cars.cursor)
	is 
		car : type_car renames element (c);
	begin
		put_line ("seats:" & positive'image (car.seats)
			& " color: " & type_color'image (car.color));
	end show_car;



	-- This is experimental stuff with the aim
	-- to change the color of a car via an access
	-- to the procedure change_color:

	procedure change_color (
		car		: in out type_car;
		color	: in type_color)
	is begin
		car.color := color;
	end change_color;

	new_color : type_color := GREEN;

	
	procedure update_element (
		container	: in out list;
		position	: in pac_cars.cursor;
		color		: in type_color;
		process		: not null access procedure (
						element	: in out type_car;
						color	: in type_color))
	is begin
		null;
		-- process (position.node.element, color);
			-- car		=> position.node.element,
			-- car		=> element (position),
			-- color	=> color);
	end update_element;

	car_cursor : pac_cars.cursor;

begin
	put_line ("demo");

	-- Add the first car to the collection.
	-- By default a car has two seats and color white:
	cars.append ((others => <>));

	-- Add a red car with 4 seats:
	cars.append ((seats => 4, color => RED));

	-- Add a blue car with 4 seats:
	cars.append ((seats => 4, color => BLUE));

	-- Show all cars:
	cars.iterate (show_car'access);

	car_cursor := cars.first;
	while has_element (car_cursor) loop

		update_element (
			container	=> cars,
			position	=> car_cursor,
			color		=> new_color,
			process		=> change_color'access);

		next (car_cursor);
	end loop;

end demo;
