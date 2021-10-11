-- This is a simple ada program, that
-- demonstrates a simple iterator for a doubly linked list.

with ada.text_io; 			use ada.text_io;
with ada.containers;		use ada.containers;
with ada.containers.doubly_linked_lists;
with ada.strings.bounded;	use ada.strings.bounded;

procedure iterate_1 is
	
	package pac_brand is new generic_bounded_length (20);
	use pac_brand;
	
	package pac_my_list is new doubly_linked_lists (pac_brand.bounded_string);
	use pac_my_list;
	
	l : pac_my_list.list;

	procedure query_brand (c : in pac_my_list.cursor) is begin
		put_line (to_string (element (c)));
	end;
				  
begin
	append (l, to_bounded_string ("FIAT"));
	append (l, to_bounded_string ("SKODA"));
	append (l, to_bounded_string ("OPEL"));
	append (l, to_bounded_string ("FORD"));

	iterate (l, query_brand'access);
	
end iterate_1;
