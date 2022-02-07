-- This is a simple ada program, that
-- demonstrates how to delete an element
-- while iterating a list.

with ada.text_io; 			use ada.text_io;
with ada.containers;		use ada.containers;
with ada.containers.doubly_linked_lists;
with ada.strings.bounded;	use ada.strings.bounded;

procedure delete_element is
	
	package pac_brand is new generic_bounded_length (20);
	use pac_brand;
	
	package pac_my_list is new doubly_linked_lists (pac_brand.bounded_string);
	use pac_my_list;

	
	procedure query_item (c : in pac_my_list.cursor) is begin
		put_line (to_string (element (c)));
	end;
	
	
	l : pac_my_list.list;
	main_cursor, backup_cursor : pac_my_list.cursor;
	delete_first : boolean := false;

	--item_to_be_deleted : constant pac_brand.bounded_string := to_bounded_string ("FIAT");
	--item_to_be_deleted : constant pac_brand.bounded_string := to_bounded_string ("OPEL");
	item_to_be_deleted : constant pac_brand.bounded_string := to_bounded_string ("FORD");
	
begin
	-- Add some elements to the list:
	append (l, to_bounded_string ("FORD"));
	append (l, to_bounded_string ("FIAT"));
	append (l, to_bounded_string ("FIAT"));
	append (l, to_bounded_string ("FORD"));
	append (l, to_bounded_string ("SKODA"));
	append (l, to_bounded_string ("OPEL"));
	append (l, to_bounded_string ("FORD"));

	
	-- We start the iteration with the first element in the list.
	-- The main cursor points to the candidate element:
	main_cursor := l.first;

	-- Iterate items:
	while main_cursor /= no_element loop

		put_line (to_string (element (main_cursor)));

		if element (main_cursor) = item_to_be_deleted then

			-- Detect whether we are about to delete
			-- the first element:
			if main_cursor = l.first then
				delete_first := true;
			else
				-- In case a deletion is required, then the
				-- cursor to the element before the candidate element
				-- must be saved. 
				-- Why ? The delete command (see below) resets the 
				-- main cursor to no_element:
				backup_cursor := previous (main_cursor);
			end if;

			
			-- Delete the candidate element:
			l.delete (main_cursor); 
			-- Now the main cursor points to no_element !

			
			if delete_first then
				-- Since we have deleted the first element,
				-- the list has now another first element.
				-- So the main cursor must be set to that first element:
				main_cursor := l.first;
				delete_first := false;
			else
				-- Restore the main cursor:
				main_cursor := backup_cursor;
				next (main_cursor);
			end if;

			
			put_line (" deleted");

		else
			next (main_cursor);
		end if;

	end loop;


	-- verify:
	new_line;
	put_line ("verify:");
	l.iterate (query_item'access);
	
end delete_element;
