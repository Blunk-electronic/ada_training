-- This is a simple ada program, that
-- demonstrates the effect of deleting an element
-- inside a vector (which is basically a list with
-- an index for each element).
-- If an element is deleted then the following elements
-- slide down so that the gap is closed. The index
-- remains a consistent row of integers.


with ada.text_io; use ada.text_io;
with ada.containers; use ada.containers;
with ada.containers.vectors;

procedure delete_element is

	package pac_characters is new vectors (
		index_type		=> positive,
		element_type	=> character);

	use pac_characters;
	
 	list : pac_characters.vector;
	cursor : pac_characters.cursor;
	

	procedure show_items is 
		length : positive;
	begin
		put_line ("-----------------------");
		
		length := positive (list.length);
		
		for i in 1 .. length loop
			put_line ("index:" & positive'image (i)
				& " item: " & list.element (i));

		end loop;
	end show_items;

	
		
begin
	-- At first we add some characters to the list:
 	list.append ('A'); -- append first item
	list.append ('B'); -- append next item
	list.append ('C');
	list.append ('D');

	-- Output the content of the list:
	show_items;

	-- Now we want to delete the element 'B'.
	-- There are two ways to accomplish that.
	-- 1. Locate the element and get a cursor that
	--    points to it. Then delete the element
	--    via this cursor.
	-- 2. Delete the element via its index.

	-- Method 1:
	cursor := list.find ('B');
	list.delete (cursor);

	-- Method 2:
	-- list.delete (2);

	-- Output the modified list:
	show_items;
	
end delete_element;
