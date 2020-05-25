-- This is a simple ada program, that
-- demonstrates the usage of a generic subprogram.

-- with ada.text_io;			use ada.text_io;
with ada.strings.unbounded; use ada.strings.unbounded;
-- with library_with_generic;

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
	end generic_pac_text;
	---------------------------

-- 	generic
-- 		with package pac_geometry is new generic_pac_geometry (<>);
-- 		with package pac_shapes is new generic_pac_shapes (<>);
-- 		with package pac_text is new generic_pac_text (<>);
-- 	package generic_pac_draw is
-- 		type type_object is null record;
-- 	end generic_pac_draw;
-- 	
	d : float := 1.0;
	
	package pac_geometry is new generic_pac_geometry (float);
	
	package pac_shapes is new generic_pac_shapes (pac_geometry);
	sl : pac_shapes.type_line := (10.0, 20.0);

	package pac_text is new generic_pac_text (float, pac_shapes);
	t : pac_text.type_text := (content => to_unbounded_string ("abc"), size => 1.0);
	tl : pac_text.type_line := (1.0, 2.0);
	
-- 	package pac_draw is new generic_pac_draw (pac_geometry, pac_shapes, pac_text);
-- 	l2 : pac_geometry.type_distance;
begin
-- 	pac_geometry.move (d);
	sl := tl;
	
	null;
end generics_4;
