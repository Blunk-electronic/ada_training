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
		object.p := (35.0, 30.0);
		
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

		-- The second dummy object is a triangle:
		object.p := (-30.0, 0.0);
		
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

		-- The third dummy object is a circle:
		object.p := (30.0, -20.0);
		
		circle := (c => (0.0, 0.0), r => 10.0, w => 1.0);
		object.circles.append (circle);

		objects_database.append (object);

	<<l_end>>
		
	end make_database;



	procedure compute_bounding_box (
		abort_on_first_error	: in boolean := false;
		ignore_errors			: in boolean := false;
		test_only				: in boolean := false)		
	is
		use pac_lines;
		use pac_circles;
		use pac_objects;

		-- debug : boolean := false;
		debug : boolean := true;
		

		-- In order to detect whether the bounding-box has
		-- changed we take a copy of the current bounding-box:
		bbox_old : type_area := bounding_box;

		-- This is the temporary bounding-box we are going to build
		-- in the course of this procedure:
		bbox_new : type_area;
		
		-- The first primitie object encountered will be the
		-- seed for bbox_new. All other objects cause 
		-- this bbox_new to expand. After the first object,
		-- this flag is cleared:
		first_object : boolean := true;


		-- This procedure iterates through all primitive objects
		-- of the drawing frame and adds them to the temporary
		-- bounding-box bbox_new:
		procedure parse_drawing_frame is

			procedure query_line (l : in pac_lines.cursor) is
				-- The candidate line being handled:
				line : type_line renames element (l);

				-- Compute the preliminary bounding-box of the line:
				b : type_area := get_bounding_box (line);
			begin
				-- Move the box by the position of the
				-- drawing frame to get the final bounding-box
				-- of the line candidate:
				move_by (b.position, drawing_frame.p);

				-- If this is the first primitive object,
				-- then use its bounding-box as seed to start from:
				if first_object then
					bbox_new := b;
					first_object := false;
				else
				-- Otherwise, merge the box b with the box being built:
					merge_areas (bbox_new, b);
				end if;
			end query_line;

			
		begin
			drawing_frame.lines.iterate (query_line'access);
			-- CS texts
		end parse_drawing_frame;


		
		-- This procedure is called each time an object of the database
		-- is processed:
		procedure query_object (oc : in pac_objects.cursor) is
			-- This is the complex candidate object being handled:
			object : type_complex_object renames element (oc);

			
			-- This procedure computes the bounding-box of a line:
			procedure query_line (lc : in pac_lines.cursor) is
				-- The candidate line being handled:
				line : type_line renames element (lc);

				-- Compute the preliminary bounding-box of the line:
				b : type_area := get_bounding_box (line);
			begin
				-- Move the box by the position of the
				-- complex object to get the final bounding-box
				-- of the line candidate:
				move_by (b.position, object.p);

				-- If this is the first primitive object,
				-- then use its bounding-box as seed to start from:
				if first_object then
					bbox_new := b;
					first_object := false;
				else
				-- Otherwise, merge the box b with the box being built:
					merge_areas (bbox_new, b);
				end if;
			end query_line;


			-- This procedure computes the bounding-box of a circle:
			procedure query_circle (cc : in pac_circles.cursor) is
				-- The candidate circle being handled:
				circle : type_circle renames element (cc);

				-- Compute the preliminary bounding-box of the circle:
				b : type_area := get_bounding_box (circle);
			begin				
				-- Move the box by the position of the
				-- complex object to get the final bounding-box
				-- of the circle candidate:
				move_by (b.position, object.p);

				-- If this is the first primitive object,
				-- then use its bounding-box as seed to start from:
				if first_object then
					bbox_new := b;
					first_object := false;
				else
				-- Otherwise, merge the box b with the box being built:
					merge_areas (bbox_new, b);
				end if;
			end query_circle;

			
		begin
			-- Iterate the lines, circles and other primitive
			-- components of the current object:
			object.lines.iterate (query_line'access);
			object.circles.iterate (query_circle'access);
			-- CS arcs
		end query_object;


		-- This procedure updates the bounding-box and
		-- sets the bounding_box_changed flag
		-- in NON-TEST-MODE (which is default by argument test_only).
		-- In TEST-mode the bounding_box_changed flag is cleared:
		procedure update_global_bounding_box is begin
			if test_only then
				put_line ("TEST ONLY mode. Bounding-box not changed.");
				bounding_box_changed := false;
			else
				-- Update the global bounding-box:
				bounding_box := bbox_new;

				-- The new bounding-box differs from the old one.
				-- Set the global flag bounding_box_changed:
				bounding_box_changed := true;
			end if;
		end update_global_bounding_box;
		
		
	begin
		put_line ("compute_bounding_box");

		-- Iterate through all primitive objects of the 
		-- drawing frame:
		parse_drawing_frame;
		
		-- The database that contains all objects of the model
		-- must be parsed. This is the call of an iteration through
		-- all objects of the database:
		objects_database.iterate (query_object'access);
		
		-- Expand the temporary bounding-box by the margin. 
		-- The margin is part of the model and thus part 
		-- of the bounding-box:
		bbox_new.width  := bbox_new.width  + 2.0 * margin;
		bbox_new.height := bbox_new.height + 2.0 * margin;
		
		-- Since we regard the margin as inside the bounding-box,
		-- we must move the bounding-box position towards bottom-left
		-- by the inverted margin_offset:
		move_by (bbox_new.position, invert (margin_offset));

		
		-- Compare the new bounding-box with the old 
		-- bounding-box to detect a change:
		if bbox_new /= bbox_old then

			-- Do the size check of the new bounding-box. If it is
			-- too large, then restore the old bounding-box:
			if bbox_new.width  >= bounding_box_width_max or
				bbox_new.height >= bounding_box_height_max then

				-- output limits and computed box dimensions:
				put_line ("WARNING: Bounding-box size limit exceeded !");
				put_line (" max. width : " & to_string (bounding_box_width_max));
				put_line (" max. height: " & to_string (bounding_box_height_max));
				put_line (" detected   : " & to_string (bbox_new));

				-- Set the error flag:
				bounding_box_error := (
					size_exceeded => true,
					width  => bbox_new.width,
					height => bbox_new.height);

				
				if ignore_errors then
					put_line (" Errors ignored !");
					
					-- Override old global bounding-box with
					-- the faulty box bbox_new:
					update_global_bounding_box;
					
				else -- By default errors are NOT ignored.
					put_line (" Discarded. Global bounding-box NOT changed.");
					
					-- Clear the global flag bounding_box_changed
					-- because we discard the new bounding-box (due to 
					-- a size error) and
					-- leave the current global bounding-box untouched:
					bounding_box_changed := false;

				end if;

				
			else -- size ok, no errors
				-- Reset error flag:
				bounding_box_error := (others => <>);

				update_global_bounding_box;
			end if;
			
			
		else -- No change. 
			-- Clear the global flag bounding_box_changed:
			bounding_box_changed := false;

			-- Reset error flag:
			bounding_box_error := (others => <>);
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

		-- The object is a square:

		-- Define the position of the square:
		object.p := (500.0, -250.0);
		
		-- In order to simulate a violation of the maximum
		-- allowed bounding-box dimensions try this:
		-- object.p := (2500.0, -250.0); -- width exceeded
		-- object.p := (500.0, -1000.0); -- height exceeded
		
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




	

	procedure make_drawing_frame is
		use pac_lines;

		-- This simple drawing frame consists of lines
		-- which have a linewidth of 1mm:
		line : type_line;
		w : type_distance_model := 1.0;
	begin
		put_line ("make_drawing_frame");

		-- Set the position of the frame (lower left corner):
		drawing_frame.p := drawing_frame_position;
		
		put_line (" frame position:" & to_string (drawing_frame.p));

		
		-- These are the four lines that make the 
		-- main rectangle (landscape format):
		line := (s => (0.0, 0.0), e => (297.0, 0.0), w => w);
		drawing_frame.lines.append (line);

		line := (s => (297.0, 0.0), e => (297.0, 210.0), w => w);
		drawing_frame.lines.append (line);

		line := (s => (297.0, 210.0), e => (0.0, 210.0), w => w);
		drawing_frame.lines.append (line);

		line := (s => (0.0, 210.0), e => (0.0, 0.0), w => w);
		drawing_frame.lines.append (line);


		
		-- The lines of the title block:
		line := (s => (200.0, 0.0), e => (200.0, 50.0), w => w);
		drawing_frame.lines.append (line);

		line := (s => (230.0, 0.0), e => (230.0, 50.0), w => w);
		drawing_frame.lines.append (line);

		
		line := (s => (200.0, 50.0), e => (297.0, 50.0), w => w);
		drawing_frame.lines.append (line);

		line := (s => (200.0, 40.0), e => (297.0, 40.0), w => w);
		drawing_frame.lines.append (line);
		
	end make_drawing_frame;

	
end demo_objects;

