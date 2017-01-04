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
	type_my_list.append(l,7);
	type_my_list.append(l,9);

	c := type_my_list.first(l);
	n := type_my_list.element(c);
	put_line(natural'image(n));

	c := type_my_list.next(c);
	n := type_my_list.element(c);
	put_line(natural'image(n));
	
end cont_doubly_linked_list_1;
