package objects is

	type type_point is tagged record
		x, y : integer;
	end record;

	function area (point : in type_point) return float;
	
	type type_circle is new type_point with record
		radius : integer;
	end record;
	
	function area (circle : in type_circle) return float;

	
	type type_rectangle is new type_point with record
		length, height : integer;
	end record;

	function area (rectangle : in type_rectangle) return float;

end objects;
