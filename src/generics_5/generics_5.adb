-- This demo shows how to use explicit package parameters.

-- with ada.text_io;			use ada.text_io;
with ada.strings.unbounded; use ada.strings.unbounded;

procedure generics_5 is

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
		-- NOTE: This use clause does not always work properly. 
		-- In that case, the prefix "pac_geometry" must be explicitely provided
		-- for types that stem from generic_pac_geometry.
		-- Otherwise the linker reports lots of "undefined references" ...
		
		type type_line is abstract tagged record start_point, end_point : type_distance; end record;
	end generic_pac_shapes;
	---------------------------

	generic
		type type_size is digits <>;
		with package pac_shapes is new generic_pac_shapes (<>);
	package generic_pac_text is
		type type_text is record content : unbounded_string; size : type_size; end record;

		use pac_shapes.pac_geometry;
		-- NOTE: This use clause does not always work properly. 
		-- In that case, the prefix "pac_geometry" must be explicitely provided
		-- for types that stem from generic_pac_geometry.
		-- Otherwise the linker reports lots of "undefined references" ...

		type type_line is new pac_shapes.type_line with null record;
	end generic_pac_text;
	---------------------------

	-- Instantiate geometry, shapes and text packages:
	package pac_geometry is new generic_pac_geometry (float);
	package pac_shapes is new generic_pac_shapes (pac_geometry);
	package pac_text is new generic_pac_text (float, pac_shapes);

	---------------------------

	generic
		with package pac_geometry is new generic_pac_geometry (<>);
		with package pac_shapes is new generic_pac_shapes (<>);

		-- no explicit parameters:
-- 		with package pac_text is new generic_pac_text (<>);

		-- with explicit parameters:
		with package pac_text is new generic_pac_text (type_size => float, pac_shapes => pac_shapes);
		
	package generic_pac_draw is
		type type_object is null record;
		procedure draw (l : in pac_shapes.type_line);
	end generic_pac_draw;

	package body generic_pac_draw is
		procedure draw (l : in pac_shapes.type_line) is begin null; end;
		procedure paint (l : in pac_text.type_line) is begin

			-- This does not compile if package pac_text has no explicit parameters:
			-- (Compiler complains: "invalid tagged conversion, not compatible with type "type_line" ...")
			draw (pac_shapes.type_line (l));

			null;
		end;
	end generic_pac_draw;


	---------------------------

	-- Instantiate draw package:
	package pac_draw is new generic_pac_draw (pac_geometry, pac_shapes, pac_text);
		
begin
	null;
end generics_5;
