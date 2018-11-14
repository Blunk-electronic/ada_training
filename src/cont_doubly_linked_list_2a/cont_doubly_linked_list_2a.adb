-- This is a simple ada program, that
-- demonstrates a doubly linked list.

with ada.text_io; use ada.text_io;
with ada.containers; use ada.containers;
with ada.containers.doubly_linked_lists;

procedure cont_doubly_linked_list_2a is

	type type_car is record
		seats	: positive;
		weight	: float;
	end record;
	
	package type_my_list is new doubly_linked_lists (type_car);
	use type_my_list;
	l : type_my_list.list;
	c : type_my_list.cursor;

begin
	append (l, (seats => 4, weight => 2.2)); -- append a car

	c := first (l); -- set cursor at begin of list
	while c /= no_element loop
		declare
			n : type_car := element (c); -- get object
		begin
			put_line (positive'image (n.seats)); -- display object
		end;

		next (c); -- advance cursor to next object
	end loop;
	
end cont_doubly_linked_list_2a;
