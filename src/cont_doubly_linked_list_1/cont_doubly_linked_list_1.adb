-- This is a simple ada program, that
-- demonstrates a doubly linked list.

with ada.text_io; use ada.text_io;
with ada.containers; use ada.containers;
with ada.containers.doubly_linked_lists;

procedure cont_doubly_linked_list_1 is
	package type_my_list is new doubly_linked_lists(natural);
	l : type_my_list.list;
	c : type_my_list.cursor;
	n : natural;
begin
	type_my_list.append(l,7); -- append object '7' to list 'l'
	type_my_list.append(l,9); -- append object '9' to list 'l'

	c := type_my_list.first(l); -- set cursor at begin of list
	n := type_my_list.element(c); -- get first object
	put_line(natural'image(n)); -- display object

	c := type_my_list.next(c); -- advance cursor to next object
	n := type_my_list.element(c); -- get next object
	put_line(natural'image(n)); -- display object
	
end cont_doubly_linked_list_1;
