-- This is a simple ada program, that
-- demonstrates a map.

with ada.text_io; use ada.text_io;
with ada.containers; use ada.containers;
with ada.containers.ordered_maps;
with ada.containers.doubly_linked_lists;

procedure cont_maps_6 is

  package my_list is new ada.containers.doubly_linked_lists(natural);
  use my_list;

	package type_my_map is new ordered_maps (
		key_type 		=> character,
		element_type	=> my_list.list);
	
	use type_my_map;

 	m : type_my_map.map;
	c : type_my_map.cursor;
	
	inserted : boolean; -- goes true if the object got inserted

	procedure change (
		name	: in character;
		thing	: in out my_list.list) is
	begin
		thing.append(100);
		thing.append(101);
	end change;

	procedure query (
		name	: in character;
		thing	: in my_list.list) is
		c : my_list.cursor := thing.first;

-- 		procedure print_item (cursor : my_list.cursor) is
-- 		begin	
-- 			put_line (natural'image (element (cursor)));
-- 		end print_item;

	begin -- query
		--thing.iterate (print_item'access);
		
		while c /= my_list.no_element loop
			put_line (natural'image (element (c)));
			next (c);
		end loop;
	end query;

begin -- cont_maps_6
	insert (  -- insert object '7' with key 'A'
		container	=> m,
		key			=> 'A',
		position	=> c,
		inserted	=> inserted
		);

	if inserted then
		update_element (
			container	=> m,
			position	=> c,
			process		=> change'access);
	end if;

	query_element (
		position	=> c,
		process		=> query'access);

end cont_maps_6;
