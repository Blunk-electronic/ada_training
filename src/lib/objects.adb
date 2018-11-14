package body objects is

	function area (point : in type_point) return float is begin
		return 0.0;
	end area;

	function area (circle : in type_circle) return float is begin
		return (3.14/4.0) * float (circle.radius) * float (circle.radius);
	end area;

	function area (rectangle : in type_rectangle) return float is begin
		return float (rectangle.length * rectangle.height);
	end area;


end objects;
