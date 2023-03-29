-- This is a simple ada program, that
-- demonstrates a list of cursors.

with ada.text_io; 			use ada.text_io;
with ada.containers;		use ada.containers;
with ada.containers.doubly_linked_lists;
with ada.strings.bounded;	use ada.strings.bounded;

procedure demo_3 is
	
	package pac_brand is new generic_bounded_length (20);
	use pac_brand;
	
	package pac_cars is new doubly_linked_lists (pac_brand.bounded_string);
	use pac_cars;
	
	cars : pac_cars.list;
	car_cursor : pac_cars.cursor;

	type type_cursor is record
		id		: positive := 1;
		cursor	: pac_cars.cursor;
	end record;
	
	-- A list of cursor types:
	package pac_cursors is new doubly_linked_lists (type_cursor);
	use pac_cursors;

	list_of_cursors : pac_cursors.list;
	
	-- procedure query_brand (c : in pac_cars.cursor) is begin
	-- 	put_line (to_string (element (c)));
	-- end;

	procedure query_cursor (c : in pac_cursors.cursor) is 
		scratch : type_cursor renames element (c);
	begin
		-- if scratch.cursor /= car_cursor then -- skip the car that was added least
			put_line ("id" & positive'image (scratch.id)
					  & " " & to_string (element (scratch.cursor)));
		-- end if;
	end;

	
begin
	append (cars, to_bounded_string ("RENAULT"));
	append (cars, to_bounded_string ("FIAT"));
	append (cars, to_bounded_string ("SKODA"));
	append (cars, to_bounded_string ("OPEL"));
	append (cars, to_bounded_string ("FORD"));

	--iterate (l, query_brand'access);

	car_cursor := cars.find (to_bounded_string ("SKODA"));
	list_of_cursors.append ((1, car_cursor));
	
	car_cursor := cars.find (to_bounded_string ("RENAULT"));
	list_of_cursors.append ((2, car_cursor));

	car_cursor := cars.find (to_bounded_string ("FIAT"));
	list_of_cursors.append ((3, car_cursor));

	
	list_of_cursors.iterate (query_cursor'access);
	
end demo_3;
