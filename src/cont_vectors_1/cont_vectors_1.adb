-- This is a simple ada program, that
-- demonstrates a vector.

with ada.text_io; use ada.text_io;
with ada.containers; use ada.containers;
with ada.containers.vectors;

procedure cont_vectors_1 is

	package type_my_vector is new 
		vectors ( index_type => positive,
				element_type => natural);

 	v : type_my_vector.vector;
 	n : natural;
begin
 	type_my_vector.append(v,7); -- add first object
 	type_my_vector.append(v,9); -- add next object

 	n := type_my_vector.element(v,2); -- get object from pos. 2
 	put_line(natural'image(n));
	
end cont_vectors_1;
