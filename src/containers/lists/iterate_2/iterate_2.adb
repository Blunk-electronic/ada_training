-- This is a simple ada program, that
-- demonstrates an extended iterator
-- with an abort option.

with ada.text_io; 			use ada.text_io;
with ada.containers;		use ada.containers;
with ada.containers.doubly_linked_lists;
with ada.strings.bounded;	use ada.strings.bounded;

procedure iterate_2 is
	
	package pac_brand is new generic_bounded_length (20);
	use pac_brand;
	
	package pac_my_list is new doubly_linked_lists (pac_brand.bounded_string);
	use pac_my_list;
	
	l : pac_my_list.list;

	valid : aliased boolean := true;

	
	procedure query_brand (c : in pac_my_list.cursor) is begin
		put_line (to_string (element (c)));

		if to_string (element (c)) = "OPEL" then
			valid := false;
			put_line ("Valid is now false. Iteration will be aborted.");
		end if;
	end;

	
	procedure iterate (
		brands : in pac_my_list.list;
		process : not null access procedure (position : in pac_my_list.cursor);
		proceed : not null access boolean)
	is
		c : pac_my_list.cursor := brands.first;
	begin
		while c /= no_element and proceed.all = true loop
			--put_line ("cancel is " & boolean'image (proceed.all));
			process (c);
			next (c);
		end loop;
	end iterate;

	
begin
	append (l, to_bounded_string ("FIAT"));
	append (l, to_bounded_string ("SKODA"));
	append (l, to_bounded_string ("OPEL"));
	append (l, to_bounded_string ("FORD"));

	-- Iterate the brands. Abort as soon as the flag "valid" goes false:
	iterate (brands => l, process => query_brand'access, proceed => valid'access);
	
end iterate_2;
