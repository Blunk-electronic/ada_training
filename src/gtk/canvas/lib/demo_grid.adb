------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                                GRID                                      --
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

with cairo;
with demo_zoom;					use demo_zoom;
with demo_visible_area;
with demo_conversions;
with demo_canvas;
with demo_scale;

package body demo_grid is


	procedure set_grid_to_scale is
		use demo_scale;
	begin
		to_model (grid.spacing.x);
		to_model (grid.spacing.y);
	end set_grid_to_scale;

	
	
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


	function get_grid_spacing (
		grid : in type_grid)
		return type_logical_pixels_positive
	is
		sg : constant type_logical_pixels := type_logical_pixels (S);
		x, y : type_logical_pixels;
	begin
		x := type_logical_pixels (grid.spacing.x) * sg;
		y := type_logical_pixels (grid.spacing.y) * sg;
		return type_logical_pixels_positive'min (x, y);
	end get_grid_spacing;



	procedure draw_grid is
		use cairo;
		use demo_conversions;
		use demo_grid;
		use demo_visible_area;
		use demo_canvas;
		
		type type_float_grid is new float; -- CS refinement required

		-- X-AXIS:

		-- The first and the last column:
		x1, x2 : type_distance_model;

		-- The start and the end of the visible area:
		ax1 : constant type_float_grid := 
			type_float_grid (visible_area.position.x);
		
		ax2 : constant type_float_grid := 
			ax1 + type_float_grid (visible_area.width);

		-- The grid spacing:
		gx : constant type_float_grid := 
			type_float_grid (grid.spacing.x);

		
		-- Y-AXIS:

		-- The first and the last row:
		y1, y2 : type_distance_model;

		-- The start and the end of the visible area:
		ay1 : constant type_float_grid := 
			type_float_grid (visible_area.position.y);
		
		ay2 : constant type_float_grid := 
			ay1 + type_float_grid (visible_area.height);

		-- The grid spacing:
		gy : constant type_float_grid := 
			type_float_grid (grid.spacing.y);

		c : type_float_grid;

		-- debug : boolean := false;

		
		procedure compute_first_and_last_column is begin
			-- Compute the first column:
			-- put_line (" ax1 " & type_float_grid'image (ax1));
			c := type_float_grid'floor (ax1 / gx);
			x1 := type_distance_model ((gx * c) + gx);
			-- put_line (" x1  " & type_distance_model'image (x1));

			-- Compute the last column:
			-- put_line (" ax2 " & type_float_grid'image (ax2));
			c := type_float_grid'floor (ax2 / gx);
			x2 := type_distance_model (gx * c);
			-- put_line (" x2  " & type_distance_model'image (x2));
		end compute_first_and_last_column;


		procedure compute_first_and_last_row is begin
			-- Compute the first row:
			-- put_line (" ay1 " & type_float_grid'image (ay1));
			c := type_float_grid'floor (ay1 / gy);
			y1 := type_distance_model ((gy * c) + gy);
			-- put_line (" y1  " & type_distance_model'image (y1));

			-- Compute the last row:
			-- put_line (" ay2 " & type_float_grid'image (ay2));
			c := type_float_grid'floor (ay2 / gy);
			y2 := type_distance_model (gy * c);
			-- put_line (" y2  " & type_distance_model'image (y2));
		end compute_first_and_last_row;
		

		-- This procedure draws the dots of the grid:
		-- 1. Assemble from the first row and the first colum a real
		--    model point MP.
		-- 2. Advance PM from row to row and column to column in a 
		--    matrix like order.
		-- 3. Draw a very small circle, which will appear like a dot,
		--    (or alternatively a very small cross) at MP.
		procedure draw_dots is 
			MP : type_vector_model;
			CP : type_logical_pixels_vector;
		begin
			-- Set the linewidth of the dots:
			set_line_width (context, to_gdouble (grid_width_dots));
			
			-- Compose a model point from the first column and 
			-- the first row:
			MP := (x1, y1);

			-- Advance PM from column to column:
			while MP.x <= x2 loop

				-- Advance PM from row to row:
				MP.y := y1;
				while MP.y <= y2 loop
					-- Convert the current real model point MP to a
					-- point on the canvas:
					CP := to_canvas (MP, S);

					-- Draw a very small circle with its center at CP:
					-- arc (context, CP.x, CP.y, 
					-- 	 radius => grid_radius_dots, angle1 => 0.0, 
					--    angle2 => 6.3);
					-- stroke (context);

					-- Alternatively, draw a very small cross at CP.
					-- This could be more efficient than a circle:
					
					-- horizontal line:
					move_to (context, 
						to_gdouble (CP.x - grid_cross_arm_length),
						to_gdouble (CP.y));
					
					line_to (context, 
						to_gdouble (CP.x + grid_cross_arm_length),
						to_gdouble (CP.y));
						

					-- vertical line:
					move_to (context, 
						to_gdouble (CP.x), 
						to_gdouble (CP.y - grid_cross_arm_length));
					
					line_to (context,
						to_gdouble (CP.x),
						to_gdouble (CP.y + grid_cross_arm_length));

											
					-- Advance one row up:
					MP.y := MP.y + grid.spacing.y;
				end loop;

				-- Advance one column to the right:
				MP.x := MP.x + grid.spacing.x;
			end loop;
		end draw_dots;


		-- This procedure draws the lines of the grid:
		procedure draw_lines is 
			MP1 : type_vector_model;
			MP2 : type_vector_model;

			CP1 : type_logical_pixels_vector;
			CP2 : type_logical_pixels_vector;

			ax1f : type_distance_model := visible_area.position.x;
			ax2f : type_distance_model := ax1f + visible_area.width;
			
			ay1f : type_distance_model := visible_area.position.y;
			ay2f : type_distance_model := ay1f + visible_area.height;
		begin
			-- Set the linewidth of the lines:
			set_line_width (context, to_gdouble (grid_width_lines));
			
			-- VERTICAL LINES:

			-- All vertical lines start at the bottom of 
			-- the visible area:
			MP1 := (x1, ay1f);

			-- All vertical lines end at the top of the 
			-- visible area:
			MP2 := (x1, ay2f);

			-- The first vertical line runs along the first column. 
			-- The last vertical line runs along the last column.
			-- This loop advances from one column to the next and
			-- draws a vertical line:
			while MP1.x <= x2 loop
				CP1 := to_canvas (MP1, S);
				CP2 := to_canvas (MP2, S);
				
				move_to (context, 
					to_gdouble (CP1.x), to_gdouble (CP1.y));
				
				line_to (context, 
					to_gdouble (CP2.x), to_gdouble (CP2.y));

				MP1.x := MP1.x + grid.spacing.x;
				MP2.x := MP2.x + grid.spacing.x;
			end loop;

			
			-- HORIZONTAL LINES:

			-- All horizontal lines start at the left edge of the 
			-- visible area:
			MP1 := (ax1f, y1);

			-- All horizontal lines end at the right edge of the 
			-- visible area:
			MP2 := (ax2f, y1);

			-- The first horizontal line runs along the first row. 
			-- The last horizontal line runs along the last row.
			-- This loop advances from one row to the next and
			-- draws a horizontal line:
			while MP1.y <= y2 loop
				CP1 := to_canvas (MP1, S);
				CP2 := to_canvas (MP2, S);
				
				move_to (context, 
					to_gdouble (CP1.x), to_gdouble (CP1.y));

				line_to (context, 
					to_gdouble (CP2.x), to_gdouble (CP2.y));

				MP1.y := MP1.y + grid.spacing.y;
				MP2.y := MP2.y + grid.spacing.y;
			end loop;
		end draw_lines;
		

	begin -- draw_grid

		-- Draw the grid if it is enabled and if the spacing
		-- is greater than the minimal required spacing:
		if grid.on = GRID_ON and then
			get_grid_spacing (grid) >= grid_spacing_min then

			
			-- put_line ("draw_grid");
			compute_first_and_last_column;
			compute_first_and_last_row;

			-- Set the color of the grid:
			set_source_rgb (context, 0.5, 0.5, 0.5); -- gray

			case grid.style is
				when STYLE_DOTS =>
					draw_dots;

				when STYLE_LINES =>
					draw_lines;
			end case;

			-- Since all dots or lines are
			-- drawn with the same linewidth and color
			-- this single stroke command is sufficient:
			stroke;
		end if;
		
	end draw_grid;

	
end demo_grid;

