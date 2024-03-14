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

		-- object.p := (-100.0, -100.0);
		-- object.p := (-50.0, 50.0);
		-- object.p := (-100.0, -250.0);

		-- The first dummy object is a square:

		
		-- POSITION:

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

		line := (s => (15.0, -10.0), e => (15.0, 10.0), w => 1.0);
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

	<<l_end>>
		
	end make_database;


	

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


end demo_objects;

