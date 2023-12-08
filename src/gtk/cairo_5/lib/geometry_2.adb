------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                               GEOMETRY 2                                 --
--                                                                          --
--                               B o d y                                    --
--                                                                          --
-- Copyright (C) 2023                                                       --
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
with glib;						use glib;

package body geometry_2 is

	procedure move_line (
		line	: in out type_line;
		offset	: in type_point_model)
	is begin
		-- CS: Optimization required. Compiler options ?
		move_by (line.s, offset);
		move_by (line.e, offset);
	end move_line;


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


	
	function areas_overlap (
		A, B : in type_area)
		return boolean
	is
		-- CS: Optimization required. Compiler options ?
		
		-- AREA A:
		-- This is the lowest x used by area A
		A_lx : type_distance_model renames A.position.x;

		-- This is the greatest x used by area A
		A_gx : constant type_distance_model := A_lx + A.width;

		
		-- This is the lowest y used by area A
		A_ly : type_distance_model renames A.position.y;

		-- This is the greatest y used by area A
		A_gy : constant type_distance_model := A_ly + A.height;


		-- AREA B:
		-- This is the lowest x used by area B
		B_lx : type_distance_model renames B.position.x;

		-- This is the greatest x used by area B
		B_gx : constant type_distance_model := B_lx + B.width;

		
		-- This is the lowest y used by area B
		B_ly : type_distance_model renames B.position.y;

		-- This is the greatest y used by area B
		B_gy : constant type_distance_model := B_ly + B.height;

	begin
		-- If all of the four criteria are true then the two areas overlap:
		if	B_lx < A_gx 
		and	B_gx > A_lx
		and	B_ly < A_gy
		and	B_gy > A_ly then
			return true;
		else
			return false;
		end if;
	end areas_overlap;


	procedure merge_areas (
		A : in out type_area;
		B : in type_area)
	is
	begin
		null;
		-- CS
	end merge_areas;

	

	function above_visibility_threshold (
		a : in type_area)
		return boolean
	is
		-- CS: Optimization required. Compiler options ?
		w : constant gdouble := to_distance (a.width);
		h : constant gdouble := to_distance (a.height);
		l : gdouble;
	begin
		-- Get the greatest of w and h:
		l := gdouble'max (w, h);

		if l > visibility_threshold then
			return true;
		else
			return false;
		end if;
		
	end above_visibility_threshold;


	procedure make_database is
		use pac_lines;
		use pac_circles;
		use pac_objects;

		object : type_complex_object_2;
		line : type_line;
	begin
		put_line ("make_database");

		object.p := (100.0, 50.0);
		
		line := (s => (-10.0, -10.0), e => (10.0, -10.0), w => 1.0);
		object.lines.append (line);

		line := (s => (10.0, -10.0), e => (10.0, 10.0), w => 1.0);
		object.lines.append (line);

		line := (s => (10.0, 10.0), e => (-10.0, 10.0), w => 1.0);
		object.lines.append (line);

		line := (s => (-10.0, 10.0), e => (-10.0, -10.0), w => 1.0);
		object.lines.append (line);

		objects_database.append (object);
		------------------------------------

		object.lines.clear;
		object.circles.clear;
		
		object.p := (200.0, 100.0);
		-- object.p := (190.0, 95.0);
		
		line := (s => (-200.0, -100.0), e => (200.0, -100.0), w => 1.0);
		object.lines.append (line);

		line := (s => (200.0, -100.0), e => (200.0, 100.0), w => 1.0);
		object.lines.append (line);

		line := (s => (200.0, 100.0), e => (-200.0, 100.0), w => 1.0);
		object.lines.append (line);

		line := (s => (-200.0, 100.0), e => (-200.0, -90.0), w => 1.0);
		object.lines.append (line);

		objects_database.append (object);


		
	end make_database;
	

	procedure make_object is
	begin
		object.lower_left_corner := (-10.0, -5.0);
		-- object.width  := 400.0;
		-- object.height := 200.0;
		
		-- object.lower_left_corner := (5.0, 5.0);
		object.width  := 390.0;
		object.height := 190.0;
	end make_object;
	
end geometry_2;

