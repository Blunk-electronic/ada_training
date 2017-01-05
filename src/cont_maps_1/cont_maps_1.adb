-- This is a simple ada program, that
-- demonstrates a map.

with ada.text_io; use ada.text_io;
with ada.containers; use ada.containers;
with ada.containers.ordered_maps;

procedure cont_maps_1 is

	package type_my_map is new 
		ordered_maps (  key_type => positive,
					element_type => natural);

 	m : type_my_map.map;
 	n : natural;
begin
	type_my_map.insert(m,123,7); -- insert object '7' with key '123'
  	type_my_map.insert(m,74188,99); -- insert object '99' with key '74188'

	n := type_my_map.element(m,74188); -- get object with key '74188'
 	put_line(natural'image(n));
	
	n := type_my_map.element(m,123); -- get object with key '123'
 	put_line(natural'image(n));
	
end cont_maps_1;
