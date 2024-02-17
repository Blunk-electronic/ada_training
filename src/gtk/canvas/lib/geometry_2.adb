------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                               GEOMETRY 2                                 --
--                                                                          --
--                               B o d y                                    --
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


package body geometry_2 is

	function to_string (
		distance : in type_distance_model)
		return string
	is begin
		return type_distance_model'image (distance);
	end to_string;

	
	function to_string (
		rotation : in type_rotation_model)
		return string
	is begin
		return type_rotation_model'image (rotation);
	end to_string;

	
	
	function to_string (
		v : in type_vector_model)
		return string
	is begin
		return "vector model x/y: "
			& to_string (v.x) & "/" & to_string (v.y);
	end to_string;


	function invert (
		point	: in type_vector_model)
		return type_vector_model
	is begin
		return (- point.x, - point.y);
	end invert;

	

	procedure move_by (
		point	: in out type_vector_model;
		offset	: in type_vector_model)
	is begin
		point.x := point.x + offset.x;
		point.y := point.y + offset.y;
	end move_by;


	
	function get_distance (
		p1, p2 : in type_vector_model)
		return type_distance_model
	is
		use pac_float_numbers_functions;

		dx : type_float := abs (type_float (p2.x - p1.x));
		dy : type_float := abs (type_float (p2.y - p1.y));
		d : type_float;
	begin
		d := sqrt (dx**2.0 + dy**2.0);
		return type_distance_model (d);
	end get_distance;
	

	function get_angle (
		p1, p2 : in type_vector_model)
		return type_rotation_model
	is
		use pac_float_numbers_functions;

		dx : type_float := type_float (p2.x - p1.x);
		dy : type_float := type_float (p2.y - p1.y);
		a : type_float;
	begin
		a := arctan (dy, dx, 360.0);
		return type_rotation_model (a);
	end get_angle;


	function snap_to_grid (
		point : in type_vector_model)
		return type_vector_model
	is
		n : integer;
		type type_float is new float; -- CS refinement required
		f : type_float;
		result : type_vector_model;
	begin
		n := integer (point.x / grid.spacing.x);
		f := type_float (n) * type_float (grid.spacing.x);
		result.x := type_distance_model (f);

		n := integer (point.y / grid.spacing.y);
		f := type_float (n) * type_float (grid.spacing.y);
		result.y := type_distance_model (f);
		
		return result;
	end snap_to_grid;


	
	function to_string (
		box : in type_area)
		return string
	is begin
		return "area (x/y/w/h): "
			& to_string (box.position) & "/"
			& to_string (box.width) & "/"
			& to_string (box.height);
	end to_string;

	
	function get_corners (
		area	: in type_area)
		return type_area_corners
	is
		result : type_area_corners;
	begin
		result.BL := (area.position.x, area.position.y);
		result.BR := (area.position.x + area.width, area.position.y);

		result.TL := (area.position.x, area.position.y + area.height); 
		result.TR := (area.position.x + area.width, area.position.y + area.height); 
		return result;
	end get_corners;


	
	function get_center (
		area	: in type_area)
		return type_vector_model
	is
		result : type_vector_model;
	begin
		result.x := area.position.x + area.width  * 0.5;
		result.y := area.position.y + area.height * 0.5;
		return result;
	end get_center;


	
	function in_area (
		point	: type_vector_model;
		area	: type_area)
		return boolean
	is
		result : boolean := false;
	begin
		-- text x-axis:
		if point.x >= area.position.x then
			if point.x <= area.position.x + area.width then

				-- test y-axis:
				if point.y >= area.position.y then
					if point.y <= area.position.y + area.height then
						result := true;
					end if;
				end if;
				
			end if;
		end if;
		
		return result;
	end in_area;


	
	function to_real (
		point : in type_vector_model)
		return type_vector_model
	is	
		result : type_vector_model := point;
	begin
		move_by (result, bounding_box.position);
		return result;
	end to_real;


	function to_virtual (
		point : in type_vector_model)
		return type_vector_model
	is
		result : type_vector_model := point;
	begin
		move_by (result, invert (bounding_box.position));
		return result;
	end to_virtual;


	
	
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
		result : type_area;
	begin
		-- CS
		return result;
	end get_bounding_box;
	
	
	
	function areas_overlap (
		A, B : in type_area)
		return boolean
	is
		-- CS: Optimization required. Compiler options ?
		-- CS: rename lx, gx, ly, gy to x1, x2, y1, y2
		
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
		-- If all of the four criteria are true then the two 
		-- areas DO overlap:
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
		-- CS: Optimization required. Compiler options ?
		
		-- AREA A:
		-- This is the lowest x used by area A
		A_lx : type_distance_model renames A.position.x;

		-- This is the greatest x used by area A
		A_gx : type_distance_model := A_lx + A.width;

		
		-- This is the lowest y used by area A
		A_ly : type_distance_model renames A.position.y;

		-- This is the greatest y used by area A
		A_gy : type_distance_model := A_ly + A.height;


		-- AREA B:
		-- This is the lowest x used by area B
		B_lx : type_distance_model renames B.position.x;

		-- This is the greatest x used by area B
		B_gx : type_distance_model := B_lx + B.width;

		
		-- This is the lowest y used by area B
		B_ly : type_distance_model renames B.position.y;

		-- This is the greatest y used by area B
		B_gy : type_distance_model := B_ly + B.height;

	begin
		-- x-axis:
		if B_lx < A_lx then
			A_lx := B_lx;
		end if;
		
		if B_gx > A_gx then
			A_gx := B_gx;
		end if;

		-- y-axis:
		if B_ly < A_ly then
			A_ly := B_ly;
		end if;
		
		if B_gy > A_gy then
			A_gy := B_gy;
		end if;

		A.width  := A_gx - A_lx;
		A.height := A_gy - A_ly;
	end merge_areas;

	



	
	procedure make_database is
		use pac_lines;
		use pac_circles;
		use pac_objects;

		object : type_complex_object;
		line : type_line;
	begin
		put_line ("make_database");

		-- object.p := (-100.0, -100.0);
		-- object.p := (-50.0, 50.0);
		-- object.p := (-100.0, -250.0);
		object.p := (10.0, 20.0);
		
		line := (s => (-10.0, -10.0), e => (10.0, -10.0), w => 1.0);
		object.lines.append (line);

		line := (s => (10.0, -10.0), e => (10.0, 10.0), w => 1.0);
		object.lines.append (line);

		line := (s => (10.0, 10.0), e => (-10.0, 10.0), w => 2.0);
		object.lines.append (line);

		line := (s => (-10.0, 10.0), e => (-10.0, -10.0), w => 2.0);
		object.lines.append (line);

		objects_database.append (object);
		------------------------------------
		-- goto l_end;
		
		object.lines.clear;
		object.circles.clear;
		
		object.p := (200.0, 100.0);
		-- object.p := (190.0, 95.0);
		
		line := (s => (-200.0, -100.0), e => (200.0, -100.0), w => 1.5);
		object.lines.append (line);

		line := (s => (200.0, -100.0), e => (200.0, 100.0), w => 1.5);
		object.lines.append (line);

		line := (s => (200.0, 100.0), e => (-200.0, 100.0), w => 1.5);
		object.lines.append (line);

		line := (s => (-200.0, 100.0), e => (-200.0, -90.0), w => 1.5);
		object.lines.append (line);

		objects_database.append (object);

		------------------------------------
		-- goto l_end;
		
		object.lines.clear;
		object.circles.clear;

		object.p := (100.0, -250.0);
		
		line := (s => (-10.0, -10.0), e => (10.0, -10.0), w => 1.0);
		object.lines.append (line);

		line := (s => (10.0, -10.0), e => (10.0, 10.0), w => 1.0);
		object.lines.append (line);

		line := (s => (10.0, 10.0), e => (-10.0, 10.0), w => 1.0);
		object.lines.append (line);

		line := (s => (-10.0, 10.0), e => (-10.0, -10.0), w => 1.0);
		object.lines.append (line);

		objects_database.append (object);

	<<l_end>>
		
	end make_database;
	

	
	procedure compute_bounding_box is
		use pac_lines;
		use pac_circles;
		use pac_objects;

		debug : boolean := false;
		--debug : boolean := true;
		
		-- The first object encountered will be the
		-- seed for the first boundinb-box. All other objects cause 
		-- this seed box to expand. After the first object,
		-- this flag is cleared:
		first_object : boolean := true;

		bbox_old : type_area := bounding_box;
		
		
		procedure query_object (oc : in pac_objects.cursor) is
			object : type_complex_object renames element (oc);

			procedure query_line (lc : in pac_lines.cursor) is
				line : type_line renames element (lc);
				b : type_area;
			begin
				b := get_bounding_box (line);
				move_by (b.position, object.p);
				
				if first_object then
					bounding_box := b;
					first_object := false;
				else
					merge_areas (bounding_box, b);
				end if;
			end query_line;

			
			procedure query_circle (cc : in pac_circles.cursor) is
				circle : type_circle renames element (cc);
				b : type_area;
			begin
				b := get_bounding_box (circle);
				move_by (b.position, object.p);

				if first_object then
					bounding_box := b;
					first_object := false;
				else
					merge_areas (bounding_box, b);
				end if;
			end query_circle;

			
		begin
			-- Iterate the lines, circles and other primitive
			-- components of the current object:
			object.lines.iterate (query_line'access);
			object.circles.iterate (query_circle'access);
			-- CS arcs
		end query_object;

		
	begin
		put_line ("compute_bounding_box");

		-- The database that contains all objects of the model
		-- must be parsed here:
		objects_database.iterate (query_object'access);
		
		-- Expand the bounding-box by the margin. 
		-- The margin is part of the model and thus part 
		-- of the bounding box:
		bounding_box.width  := bounding_box.width  + 2.0 * margin;
		bounding_box.height := bounding_box.height + 2.0 * margin;
		
		-- Since we regard the margin as inside the bounding-box,
		-- we must move the bounding-box position towards bottom-left
		-- by the inverted margin_offset:
		move_by (bounding_box.position, invert (margin_offset));

		if bounding_box /= bbox_old then
			bounding_box_changed := true;
		else
			bounding_box_changed := false;
		end if;
		
		if debug then
			put_line ("bounding-box: " & to_string (bounding_box));

			if bounding_box_changed then
				put_line (" has changed");
			end if;
		end if;
	end compute_bounding_box;

	

	procedure add_object is
		use pac_lines;
		use pac_circles;
		use pac_objects;

		object : type_complex_object;
		line : type_line;

	begin
		-- put_line ("add_object");

		object.p := (500.0, -250.0);
		
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


	
end geometry_2;

