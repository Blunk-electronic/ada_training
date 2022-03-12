-- Here we demonstrate dynamic dispatching:

with ada.text_io; 	use ada.text_io;
with objects; 		

procedure tagged_types_3 is

	use objects;
	
	procedure calculate_area (object : in type_point'class) is 
	begin
		put_line (float'image (area (object)));
	end calculate_area;

	p : type_point := (x => 4, y => 5);
	c : type_circle := (x => 4, y => 5, radius => 10);
	r : type_rectangle := (x => 4, y => 5, length => 10, height => 11);	
begin
	calculate_area (p);
	calculate_area (c);	
	calculate_area (r);		
end tagged_types_3;
