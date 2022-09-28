-- This is a simple ada program, that
-- demonstrates the usage of a package parameters.

with ada.text_io;			use ada.text_io;
with ada.strings.unbounded; use ada.strings.unbounded;

procedure generics_4a is

	generic
		type type_distance is delta <>;
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
		type type_size is delta <>;
		with package pac_shapes is new generic_pac_shapes (<>);
	package generic_pac_text is
		use pac_shapes;
		use pac_geometry;
		
		type type_text is record content : unbounded_string; size : type_size; end record;
		type type_line is record start_point, end_point : type_distance; end record;
		l : pac_shapes.type_line;

		function dummy (i : in type_distance) return natural;
		function dummy (i : in type_distance) return string;
		
	end generic_pac_text;

	package body generic_pac_text is
		function dummy (i : in type_distance) return natural is begin 
			return 1;
		end dummy;
	
		function dummy (i : in type_distance) return string is begin
			return "test";
		end dummy;
	end generic_pac_text;
	---------------------------

	type type_distance is delta 0.01 range -100_000_000.00 .. 100_000_000.00;
	for type_distance'small use 0.01;

	
	package pac_geometry is new generic_pac_geometry (type_distance);
	
	package pac_shapes is new generic_pac_shapes (pac_geometry);
	sl : pac_shapes.type_line := (10.0, 20.0);

	package pac_text is new generic_pac_text (type_distance, pac_shapes);
	
	n : natural;
begin
	n := pac_text.dummy (0.0);

	put_line (pac_text.dummy (0.0));
	
	null;
end generics_4a;
