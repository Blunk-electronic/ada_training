-- This is a simple ada program, that
-- demonstrates a doubly linked list.

with ada.text_io; use ada.text_io;
with ada.containers; use ada.containers;
with ada.containers.doubly_linked_lists;
with ada.strings.bounded;

procedure cont_doubly_linked_list_3 is
	USE ada.strings.bounded;
	
	package type_brand is new  generic_bounded_length (20);
	
	package type_my_list is new doubly_linked_lists (
		element_type	=> type_brand.bounded_string,
		"="				=> type_brand."=");
	
	use type_my_list;
	l : type_my_list.list;
	c : type_my_list.cursor;

begin
	append (l, type_brand.to_bounded_string ("FIAT")); -- append a brand
	append (l, type_brand.to_bounded_string ("SKODA")); -- append a brand	
 	
end cont_doubly_linked_list_3;
