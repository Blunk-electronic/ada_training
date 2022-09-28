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
		type type_rectangle is record height, width : type_distance := 1.0; end record;
		type type_line is tagged record start_point, end_point : type_distance; end record;
	end generic_pac_shapes;
	---------------------------

	generic
		type type_size is digits <>;
		with package pac_shapes is new generic_pac_shapes (<>);
	package generic_pac_text is
		type type_text is record content : unbounded_string; size : type_size; end record;

		use pac_shapes;
		bounding_box : type_rectangle;

		type type_line is new pac_shapes.type_line with null record;
	end generic_pac_text;
	---------------------------

	-- Instantiate geometry, shapes and text packages:
	package pac_geometry is new generic_pac_geometry (float);
	package pac_shapes is new generic_pac_shapes (pac_geometry);
	package pac_text is new generic_pac_text (float, pac_shapes);

	---------------------------

	generic
		-- no explicit parameters:
		--with package pac_text is new generic_pac_text (<>);

		-- with explicit parameters:
		with package pac_text is new generic_pac_text (type_size => float, pac_shapes => pac_shapes);
		-- NOTE: This also allows access to the stuff that comes along with pac_shapes
		-- such as pac_geometry and pac_shapes.
		
	package generic_pac_draw is
		-- Declare a distance of type_distance taken from imported pac_shapes:
		dx : pac_geometry.type_distance := 0.0;
		
		-- Get visibilty of stuff from geometry package (inside pac_shapes):
		use pac_geometry;
		dy : type_distance := 0.0;

		line_shapes : pac_shapes.type_line;
		line_text   : pac_text.type_line;
		
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

	-- Instantiate the draw package:
	package pac_draw is new generic_pac_draw (pac_text);
	--use pac_draw;
	
	dummy : pac_draw.type_object;
	
	f1 : float := 1.0;
	f2 : float := 2.0;
	ls : pac_shapes.type_line := (f1, f2);
	lt : pac_text.type_line := (f1, f2);

	box : pac_shapes.type_rectangle;
begin
	pac_draw.draw (ls);
	
end generics_5;
