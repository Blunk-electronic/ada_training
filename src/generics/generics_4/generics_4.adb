-- This is a simple ada program, that
-- demonstrates the usage of package parameters.

-- with ada.text_io;			use ada.text_io;
with ada.strings.unbounded; use ada.strings.unbounded;


procedure generics_4 is

	generic
		type type_distance is digits <>;
	package generic_pac_geometry is
		procedure move (d : in out type_distance);
	end generic_pac_geometry;
	
	package body generic_pac_geometry is
		procedure move (d : in out type_distance) is begin
			d := d + 1.0;
		end move;
	end generic_pac_geometry;
	----------------------------

	generic
		with package pac_geometry is new generic_pac_geometry (<>);
	package generic_pac_shapes is
		use pac_geometry;
		type type_line is record start_point, end_point : type_distance; end record;
	end generic_pac_shapes;
	---------------------------

	generic
		type type_size is digits <>;
		with package pac_shapes is new generic_pac_shapes (<>);
	package generic_pac_text is
		type type_text is record content : unbounded_string; size : type_size; end record;
		use pac_shapes.pac_geometry;
		type type_line is record start_point, end_point : type_distance; end record;
		l : pac_shapes.type_line;
	end generic_pac_text;
	---------------------------

	-- Declare a distance of 1m:
	d : float := 1.0;

	
	-- Instantiate the geometry package:
	package pac_geometry is new generic_pac_geometry (float);

	-- Instantiate the shapes package with the (instantiated) geometry package:	
	package pac_shapes is new generic_pac_shapes (pac_geometry);

	-- Declare a line taken from the shapes package:
	sl : pac_shapes.type_line := (10.0, 20.0);
	------------------------------------------------
	
	-- Instantiate the text package with a size parameter and the 
	-- (instantiated) shapes package:
	package pac_text is new generic_pac_text (type_size => float, pac_shapes => pac_shapes);

	-- Declare a text:
	t : pac_text.type_text := (content => to_unbounded_string ("abc"), size => 1.0);

	-- Declare a line taken from the text package:
	tl : pac_text.type_line := (1.0, 2.0);

	
	-- l2 : pac_geometry.type_distance;
begin
	pac_geometry.move (d);
	
	-- sl := tl; -- does not compile because the lines stem from different packages !
	
	null;
end generics_4;
