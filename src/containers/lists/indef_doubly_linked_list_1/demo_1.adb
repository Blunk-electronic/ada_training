-- This is a simple ada program, that
-- demonstrates an indefinite doubly linked list.

with ada.text_io; 			use ada.text_io;
with ada.containers;		use ada.containers;
with ada.containers.indefinite_doubly_linked_lists;

procedure demo_1 is

	type type_position is record
		x, y : float;
	end record;
	
	type type_object (has_heigth : boolean) is record
		position : type_position;

		case has_heigth is
			when TRUE => height : float;
			when FALSE => null;
		end case;
	end record;
	----------------------------------------------------------
		
	package pac_objects is new indefinite_doubly_linked_lists (type_object);
	use pac_objects;
	
	objects : pac_objects.list;
	selected : pac_objects.cursor;
	
	-----------------------------------------------------------
	procedure add_objects is begin
		objects.append ((
			has_heigth	=> TRUE,
			height		=> 1.0,				
			position	=> (0.0, 0.0)));

		objects.append ((
			has_heigth	=> FALSE,
			position	=> (4.0, 7.0)));

		objects.append ((
			has_heigth	=> TRUE,
			height		=> 7.0,				
			position	=> (5.0, 1.0)));

		objects.append ((
			has_heigth	=> FALSE,
			position	=> (33.0, 77.0)));

		
		selected := objects.last;
	end add_objects;


	procedure show_objects is 
		procedure query_object (c : in pac_objects.cursor) is 
			object : type_object renames element (c);
		begin
			new_line;
			put_line ("pos   :" & float'image (object.position.x) & float'image (object.position.y));

			if object.has_heigth then
				put_line ("height:" & float'image (object.height));
			end if;
			
		end query_object;

	begin
		objects.iterate (query_object'access);
	end show_objects;


	procedure show_selected is begin
		new_line;
		put_line ("selected");
		put_line ("pos   :" 
			& float'image (element (selected).position.x) 
			& float'image (element (selected).position.y));
	end show_selected;
		
begin
	add_objects;

	show_objects;

	show_selected; 	
end demo_1;
