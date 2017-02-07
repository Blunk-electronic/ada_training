-- This simple ada program demonstrates simple 
-- mathematic operations.

with ada.text_io;	use ada.text_io;
with ada.numerics.generic_elementary_functions;
--with ada.numerics.real_arrays;  use ada.numerics.real_arrays;

procedure operations_math_2 is

	package functions is new 
		ada.numerics.generic_elementary_functions (float);
		n : float := 16.0;

	type type_coordinate is record
		x,y : float;
	end record;

	function distance_of_point_from_line ( point, line_start, line_end: in type_coordinate) return float is
		d : float;

		s1,s2,s3,s4,s5,s6,s7,s8 : float;
	begin
		s1 := (line_end.y - line_start.y) * point.x;
		s2 := (line_end.x - line_start.x) * point.y;
		s3 := line_end.x * line_start.y;
		s4 := line_end.y * line_start.x;

		s5 := abs(s1 - s2 + s3 - s4);

		s6 := (line_end.y - line_start.y)**2;
		s7 := (line_end.x - line_start.x)**2;

		s8 := functions.sqrt(s6+s7);

		d := s5 / s8;
		
		return d;
	end distance_of_point_from_line;

	

	p : type_coordinate := ( x => 1.0, y => 1.0);
	
	s : type_coordinate := ( x => -5.0, y => -5.0);
	e : type_coordinate := ( x => -5.0, y => 5.0);	
begin
	put_line ("distance of p from line s..e :" & float'image(distance_of_point_from_line(p,s,e)));

end operations_math_2;
