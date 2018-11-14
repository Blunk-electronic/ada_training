-- This is a simple ada program, that
-- demonstrates a doubly linked list.

with ada.text_io; use ada.text_io;
with ada.containers; use ada.containers;
with ada.containers.doubly_linked_lists;

procedure cont_doubly_linked_list_2 is
	package type_my_list is new doubly_linked_lists (natural);
	use type_my_list;
	l : type_my_list.list;
	c : type_my_list.cursor;
	n : natural;
begin
	append (l,7); -- append object '7' to list 'l'
	append (l,9); -- append object '9' to list 'l'
	append (l,2); -- append object '2' to list 'l'

	c := first (l); -- set cursor at begin of list
	while c /= no_element loop
		n := element (c); -- get object
		
		put_line (natural'image (n)); -- display object

		next (c); -- advance cursor to next object
	end loop;
	
end cont_doubly_linked_list_2;
