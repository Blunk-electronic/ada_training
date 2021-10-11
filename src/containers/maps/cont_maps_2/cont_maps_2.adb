-- This is a simple ada program, that
-- demonstrates a map.

with ada.text_io; use ada.text_io;
with ada.containers; use ada.containers;
with ada.containers.ordered_maps;

procedure cont_maps_2 is

	package type_my_map is new 
		ordered_maps (  key_type => character,
					element_type => natural);

 	m : type_my_map.map;
 	n : natural;
begin
	type_my_map.insert(m,'A',7); -- insert object '7' with key 'A'
  	type_my_map.insert(m,'X',99); -- insert object '99' with key 'X'

	n := type_my_map.element(m,'X'); -- get object with key 'X'
 	put_line(natural'image(n));
	
	n := type_my_map.element(m,'A'); -- get object with key 'A'
 	put_line(natural'image(n));
	
end cont_maps_2;
