-- This is a simple ada program, that
-- demonstrates an indefinitely doubly linked list.

with ada.text_io; 		use ada.text_io;
with ada.containers; 	use ada.containers;
with ada.containers.indefinite_doubly_linked_lists;

procedure cont_doubly_linked_list_2b is

	type type_car (broken : boolean) is record
		seats	: positive;
		weight : float;
		case broken is
			when false => null;
			when true => damage : float;
		end case;
	end record;
	
	package type_my_list is new indefinite_doubly_linked_lists (type_car);
	use type_my_list;
	l : type_my_list.list;
	c : type_my_list.cursor;

begin
	append (l, (broken => true, seats => 9, weight => 1.3, damage => 40.9)); -- a broken car
	append (l, (broken => false, seats => 4, weight => 2.2)); -- a good a car	

	c := first (l); -- set cursor at begin of list
	while c /= no_element loop
		declare
			n : type_car := element (c); -- get object
		begin
			put_line (positive'image (n.seats)); -- display object
		end;

		next (c); -- advance cursor to next object
	end loop;
	
end cont_doubly_linked_list_2b;
