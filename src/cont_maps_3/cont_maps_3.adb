-- This is a simple ada program, that
-- demonstrates a map.

with ada.text_io; use ada.text_io;
with ada.containers; use ada.containers;
with ada.containers.ordered_maps;

procedure cont_maps_3 is

	package type_my_map is new 
		ordered_maps (  key_type => character,
					element_type => natural);
	use type_my_map;

 	m : type_my_map.map;
 	n : natural;
	c : type_my_map.cursor;
begin
	type_my_map.insert(m,'A',7); -- insert object '7' with key 'A'
  	type_my_map.insert(m,'X',99); -- insert object '99' with key 'X'
  	type_my_map.insert(m,'Z',4); -- insert object '99' with key 'X'

	c := first(m);

	while c /= no_element loop

		n := element(c);
		next(c);
		put_line(natural'image(n));

	end loop;

end cont_maps_3;
