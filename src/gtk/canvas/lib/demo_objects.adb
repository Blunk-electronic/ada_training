------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                                OBJECTS                                   --
--                                                                          --
--                                B o d y                                   --
--                                                                          --
-- Copyright (C) 2024                                                       --
-- Mario Blunk / Blunk electronic                                           --
-- Buchfinkenweg 3 / 99097 Erfurt / Germany                                 --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
------------------------------------------------------------------------------

--   For correct displaying set tab width in your editor to 4.

--   The two letters "CS" indicate a "construction site" where things are not
--   finished yet or intended for the future.

--   Please send your questions and comments to:
--
--   info@blunk-electronic.de
--   or visit <http://www.blunk-electronic.de> for more contact data
--
--   history of changes:
--

with ada.text_io;				use ada.text_io;
with cairo;

with demo_zoom;
with demo_conversions;
with demo_primitive_draw_ops;
with demo_canvas;


package body demo_objects is

	function get_bounding_box (
		line : in type_line)
		return type_area
	is
		-- CS: Optimization required. Compiler options ?
		
		result : type_area;
		w, h : type_distance_model;

		d : constant type_distance_model := line.w / 2.0;
	begin
		-- x-axis:
		w := line.e.x - line.s.x;
		
		if w > 0.0 then -- line runs from left to right
			result.position.x := line.s.x;
			result.width := w;
		else -- line runs from right to left or vertically
			result.position.x := line.e.x;
			result.width := -w;
		end if;
		
		-- y-axis:
		h := line.e.y - line.s.y;
		
		if h > 0.0 then -- line runs upwards
			result.position.y := line.s.y;
			result.height := h;
		else -- line runs downwards or horizontally
			result.position.y := line.e.y;
			result.height := -h;
		end if;

		-- extend the box by the linewidth:
		result.width  := result.width  + line.w;
		result.height := result.height + line.w;

		-- shift the box by half the linewidth down and left:
		result.position.x := result.position.x - d;
		result.position.y := result.position.y - d;
		return result;
	end get_bounding_box;


	procedure move_line (
		line	: in out type_line;
		offset	: in type_vector_model)
	is begin
		-- CS: Optimization required. Compiler options ?
		move_by (line.s, offset);
		move_by (line.e, offset);
	end move_line;

	
	
	function get_bounding_box (
		circle : in type_circle)
		return type_area
	is
		-- CS: Optimization required. Compiler options ?
		
		result : type_area;
		w : type_distance_model;

		d : constant type_distance_model := circle.w / 2.0;
	begin
		w := 2.0 * (circle.r + d);

		result.width := w;
		result.height := w;

		result.position.x := circle.c.x - w / 2.0;
		result.position.y := circle.c.y - w / 2.0;
		
		return result;
	end get_bounding_box;



	procedure move_circle (
		circle	: in out type_circle;
		offset	: in type_vector_model)
	is begin
		-- CS: Optimization required. Compiler options ?
		move_by (circle.c, offset);
	end move_circle;

	

	procedure make_database is
		use pac_lines;
		use pac_circles;
		use pac_objects;

		object 	: type_complex_object;
		line 	: type_line;
		circle 	: type_circle;
		
	begin
		put_line ("make_database");

		-- goto l_end;
		
		-- POSITION:

		-- Mind drawing_frame_position in package demo_frame
		-- for the origin of the drawing.
		
		-- The first dummy object is a square:
		-- Define the position of the square:
		object.position := (35.0, 30.0);


		-- PRIMITIVE OBJECTS:

		-- IMPORTANT: The primitve objects are defined as if
		-- the object was placed on position (0;0).
		-- When the object is drawn on the canvas or when
		-- the bounding-box is computed, then the primitve
		-- objects are moved by the object position (see assignment above).
		
		line := (s => (-15.0, -10.0), e => (15.0, -10.0), w => 1.0);
		object.lines.append (line);

		line := (s => (15.0, -10.0), e => (15.0, 10.0), w => 0.1);
		object.lines.append (line);

		line := (s => (15.0, 10.0), e => (-15.0, 10.0), w => 1.0);
		object.lines.append (line);

		line := (s => (-15.0, 10.0), e => (-15.0, -10.0), w => 1.0);
		object.lines.append (line);

		objects_database.append (object);
		------------------------------------
		-- goto l_end;

		object.lines.clear;
		object.circles.clear;

		-- The 2nd dummy object is a triangle:
		
		-- POSITION:
		
		-- Define the position of the triangle:
		object.position := (-30.0, 0.0);


		-- PRIMITIVE OBJECTS:

		-- IMPORTANT: The primitve objects are defined as if
		-- the object was placed on position (0;0).
		-- When the object is drawn on the canvas or when
		-- the bounding-box is computed, then the primitve
		-- objects are moved by the object position (see assignment above).

		line := (s => (-10.0, -10.0), e => (10.0, -10.0), w => 1.0);
		object.lines.append (line);

		line := (s => (10.0, -10.0), e => (0.0, 20.0), w => 1.0);
		object.lines.append (line);

		line := (s => (0.0, 20.0), e => (-10.0, -10.0), w => 1.0);
		object.lines.append (line);


		objects_database.append (object);

		------------------------------------
		-- goto l_end;
		
		object.lines.clear;
		object.circles.clear;

		-- The 3rd dummy object is a circle:
		object.position := (30.0, -20.0);
		
		circle := (c => (0.0, 0.0), r => 10.0, w => 1.0);
		object.circles.append (circle);

		objects_database.append (object);

	end make_database;


	
	procedure make_database_2 is
		
		procedure make_object (
			destination : in type_vector_model)
		is
			use pac_lines;
			use pac_circles;
			use pac_objects;

			O : type_complex_object;
			L : type_line;
		begin
			O.position := destination;

			-- IMPORTANT: The primitve objects are defined as if
			-- the object was placed on position (0;0).
			-- When the object is drawn on the canvas or when
			-- the bounding-box is computed, then the primitve
			-- objects are moved by the object position (see assignment above).

			-- The object to be created is a square:
			L := (s => (-5.0, -5.0), e => (5.0, -5.0), w => 1.0);
			O.lines.append (L);
   
			L := (s => (5.0, -5.0), e => (5.0, 5.0), w => 1.0);
			O.lines.append (L);
   
			L := (s => (5.0, 5.0), e => (-5.0, 5.0), w => 1.0);
			O.lines.append (L);
   
			L := (s => (-5.0, 5.0), e => (-5.0, -5.0), w => 1.0);
			O.lines.append (L);

			objects_database.append (O);
		end make_object;

		-- The first object will be placed here:
		-- position : type_vector_model := (10.0, 10.0);
		position : type_vector_model := (-140.0, -90.0);
		
	begin
		put_line ("make_database_2");

		-- This creates some squares spread across the sheet:
-- 		for column in 1 .. 10 loop			
-- 			for row in 1 .. 15 loop
-- 				make_object (position);
-- 				position.x := position.x + 20.0;
-- 			end loop;
-- 		
-- 			position.x := 10.0;
-- 			position.y := position.y + 20.0;
-- 		end loop;

		-- CS usa a switch to activate:
		
		-- This creates 10.000 squares:
		for column in 1 .. 400 loop			
			for row in 1 .. 400 loop
				make_object (position);
				position.x := position.x + 1.0;
			end loop;
		
			position.x := -140.0;
			position.y := position.y + 1.0;
		end loop;

	end make_database_2;

	

	procedure add_object is
		use pac_lines;
		use pac_circles;
		use pac_objects;

		object : type_complex_object;
		line : type_line;

	begin
		-- put_line ("add_object");

		-- The 1st object is a square:

		
		-- POSITION:

		-- Define the position of the square:
		object.position := (-200.0, 0.0);
		
		-- In order to simulate a violation of the maximum
		-- allowed bounding-box dimensions try this:
		-- object.p := (2500.0, -250.0); -- width exceeded
		-- object.p := (500.0, -1000.0); -- height exceeded

		
		-- PRIMITIVE OBJECTS:

		-- IMPORTANT: The primitve objects are defined as if
		-- the object was placed on position (0;0).
		-- When the object is drawn on the canvas or when
		-- the bounding-box is computed, then the primitve
		-- objects are moved by the object position (see assignment above).
		
		line := (s => (-10.0, -10.0), e => (10.0, -10.0), w => 1.0);
		object.lines.append (line);

		line := (s => (10.0, -10.0), e => (10.0, 10.0), w => 1.0);
		object.lines.append (line);

		line := (s => (10.0, 10.0), e => (-10.0, 10.0), w => 1.0);
		object.lines.append (line);

		line := (s => (-10.0, 10.0), e => (-10.0, -10.0), w => 1.0);
		object.lines.append (line);

		objects_database.append (object);		
	end add_object;

	
	procedure delete_object is
		use pac_objects;
	begin
		put_line ("delete_object");

		objects_database.delete_last;
	end delete_object;



	procedure draw_objects is
		use cairo;
		use demo_primitive_draw_ops;
		use demo_canvas;
		use demo_conversions;
		use pac_lines;
		use pac_circles;
		use pac_objects;


		procedure query_object (oc : in pac_objects.cursor) is
			object : type_complex_object renames element (oc);


			procedure draw_origin is

				-- This procedure draws the origin as a cross of fixed size.
				-- It is independed of the scale factor.
				-- The drawing is done directly with canvas coordinates:
				procedure fixed_size is
					use demo_zoom;
					cp : type_logical_pixels_vector;
				begin
					-- Compute the center of the origin as canvas point:
					cp := to_canvas (object.position, S, true);

					-- Set the linewidth:
					set_line_width (context, to_gdouble (fixed_origin_linewidth));

					-- Draw the horizontal line from left to right:
					move_to (context, 
						to_gdouble (cp.x - fixed_origin_arm_lenght), to_gdouble (cp.y));
					
					line_to (context, 
						to_gdouble (cp.x + fixed_origin_arm_lenght), to_gdouble (cp.y));

					-- Draw the vertical line from top to bottom:
					move_to (context, 
						to_gdouble (cp.x), to_gdouble (cp.y - fixed_origin_arm_lenght));
					
					line_to (context, 
							to_gdouble (cp.x), to_gdouble (cp.y + fixed_origin_arm_lenght));

					stroke;
				end fixed_size;


				
				-- This procedure draws the origin as a cross of variable size.
				-- The size depends on the scale factor.
				-- The drawing is in model coordinates:
				procedure variable_size is
					-- The linewidth can be set here. Start and end point
					-- will follow later:
					line : type_line := (w => variable_origin_linewidth, others => <>);
				begin
					-- horizontal line:
					line.s := (x => - variable_origin_arm_length, y => 0.0); -- start
					line.e := (x => + variable_origin_arm_length, y => 0.0); -- end
					
					draw_line (line, object.position, true);
					
					-- vertical line:
					line.s := (x => 0.0, y => - variable_origin_arm_length); -- start
					line.e := (x => 0.0, y => + variable_origin_arm_length); -- end

					draw_line (line, object.position, true);
				end variable_size;
				
				
			begin
				-- Set the color of the origin:
				set_source_rgb (context, 0.5, 0.5, 0.5); -- gray

				-- Here we decide whether to draw the origin with a
				-- variable or a fixed size:
				if origin_fixed_size then
					fixed_size;
				else
					variable_size;
				end if;

			end draw_origin;
			
			
			procedure query_line (lc : in pac_lines.cursor) is
				line : type_line renames element (lc);
			begin
				--put_line ("query_line");

				-- If the line candidate has a special color,
				-- then the color must be set here.

				-- If the line candidate has a special color
				-- or a special linewidth then the draw routine
				-- must perfom a dedicated stroke:
				draw_line (line, object.position, true);

				-- If lots of lines have the same linewidth
				-- and color then this call is sufficient
				-- and takes less time to execute:
				-- draw_line (line, object.position);

				-- If the line candidate has a special color,
				-- then a dedicated stroke command is required here.
			end query_line;

			
			procedure query_circle (cc : in pac_circles.cursor) is
				circle : type_circle renames element (cc);
			begin
				-- put_line ("query_circle");

				-- If the circle candidate has a special color,
				-- then the color must be set here.

				-- If the circle candidate has a special color
				-- or a special linewidth then the draw routine
				-- must perfom a dedicated stroke:
				draw_circle (circle, object.position, true);
				
				-- If lots of arcs have the same linewidth
				-- and color then this call is sufficient
				-- and takes less time to execute:
				-- draw_circle (circle, object.position);

				-- If the circle candidate has a special color,
				-- then a dedicated stroke command is required here.
			end query_circle;

			
		begin
			--put_line ("query_object");
			draw_origin;

			-- If lots of primitive objects are to be drawn
			-- with all having the same color then do:
			set_source_rgb (context, 1.0, 0.0, 0.0);

			-- If lots of primitive objects are to be drawn
			-- with all having the same linewidth then do:
			-- set_line_width (context, to_gdouble (to_distance (1.0)));
			
			object.lines.iterate (query_line'access);
			object.circles.iterate (query_circle'access);

			-- If lots of primitive objects are to be drawn
			-- with all having the same linewidth and color
			-- then a single stroke command is sufficient:
			-- stroke;
		end query_object;

		
	begin
		--put_line ("draw_objects");
		
		objects_database.iterate (query_object'access);
	end draw_objects;

	
end demo_objects;

