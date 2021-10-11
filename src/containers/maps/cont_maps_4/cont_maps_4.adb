-- This is a simple ada program, that
-- demonstrates a map.

with ada.text_io; use ada.text_io;
with ada.containers; use ada.containers;
with ada.containers.ordered_maps;

procedure cont_maps_4 is

	package type_my_map is new ordered_maps (
		key_type 		=> character,
		element_type	=> natural);
	
	use type_my_map;

 	m : type_my_map.map;
	c : type_my_map.cursor;
	
	inserted : boolean; -- goes true if the object got inserted
begin
	insert (  -- insert object '7' with key 'A'
		container	=> m,
		key			=> 'A',
		new_item	=> 7,
		position	=> c,
		inserted	=> inserted
		);

	-- if inserted then ...
end cont_maps_4;
