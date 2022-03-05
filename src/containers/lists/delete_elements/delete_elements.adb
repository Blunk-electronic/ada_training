-- This is a simple ada program, that
-- demonstrates how to delete many elements
-- from a list using the "count"-argument.

with ada.text_io; 			use ada.text_io;
with ada.containers;		use ada.containers;
with ada.containers.doubly_linked_lists;

procedure delete_elements is

	package pac_my_list is new doubly_linked_lists (positive);
	use pac_my_list;

	
	procedure query_item (c : in pac_my_list.cursor) is begin
		put_line (natural'image (element (c)));
	end;
		
	l : pac_my_list.list;

	procedure show_list is begin
		new_line;
		put_line ("list contains:");
		l.iterate (query_item'access);
	end show_list;


	cursor : pac_my_list.cursor;
	
begin
	-- Add some positive numbers to the list:
	l.append (1);
	l.append (2);
	l.append (3);
	l.append (4);
	l.append (5);
	l.append (6);
	
	show_list; -- 1,2,3,4,5,6

	-- set cursor to item 3:
	cursor := l.find (3);

	-- delete 2 items from (and including) cursor position:
	l.delete (
		position	=> cursor,
		count		=> 2);		 

	show_list; -- 1,2, 5,6


	
	-- set cursor to item 5:
	cursor := l.find (5);

	-- After item 5 there is only one item.

	-- An attempt to delete more items than acutally available
	-- causes the command to delete as many items as possible:
	l.delete (
		position	=> cursor,
		count		=> 10);
		--count		=> 1);

	show_list; -- 1,2

	
end delete_elements;
