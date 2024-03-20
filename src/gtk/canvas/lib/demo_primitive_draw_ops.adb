------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                         PRIMITIVE DRAW OPERATIONS                        --
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

-- with glib;						use glib;
with cairo;						use cairo;

with demo_logical_pixels;		use demo_logical_pixels;
with demo_scale_factor;			use demo_scale_factor;
with demo_conversions;			use demo_conversions;
with demo_visible_area;			use demo_visible_area;
with demo_visibility;			use demo_visibility;
with demo_canvas;				use demo_canvas;


package body demo_primitive_draw_ops is

	procedure draw_line (
		line	: in type_line;
		pos		: in type_vector_model)
	is
		-- CS: Optimization required. Compiler options ?
		
		-- Make a copy of the given line:
		l : type_line := line;

		-- When the line is drawn, we need canvas points
		-- for start and end:
		c1, c2 : type_logical_pixels_vector; -- start and end of the line

		-- The bounding-box of the line. It is required
		-- for the area and size check:
		b : type_area;
		
	begin
		-- Move the line to the given position:
		move_line (l, pos);
		
		-- Get the bounding-box of line:
		b := get_bounding_box (l);
		-- put_line ("b " & to_string (b));
		
		-- Do the area check. If the bounding-box of the line
		-- is inside the visible area then draw the line. Otherwise
		-- nothing will be drawn:
		if areas_overlap (visible_area, b) and then

			-- Do the size check. If the bounding-box is greater
			-- (either in width or heigth) than the visiblity threshold
			-- then draw the line. Otherwise nothing will be drawn:
			above_visibility_threshold (b) then

			--put_line ("draw line");

			set_line_width (context, to_gdouble (to_distance (line.w)));

			c1 := to_canvas (l.s, S, real => true);
			c2 := to_canvas (l.e, S, real => true);

			-- These draw operations consume the most time:
			move_to (context, to_gdouble (c1.x), to_gdouble (c1.y));
			line_to (context, to_gdouble (c2.x), to_gdouble (c2.y));

			-- Direct conversion to gdouble does not improve performance:
			-- move_to (context, gdouble (c1.x), gdouble (c1.y));
			-- line_to (context, gdouble (c2.x), gdouble (c2.y));

			
			stroke (context);
		end if;
	end draw_line;

	
	procedure draw_circle (
		circle	: in type_circle;
		pos		: in type_vector_model)
	is
		-- CS: Optimization required. Compiler options ?
		
		-- Make a copy of the given circle:
		c : type_circle := circle;

		-- When the circle is drawn, we need a canvas point
		-- for the center:
		m : type_logical_pixels_vector;

		r : type_logical_pixels_positive;
		
		-- The bounding-box of the circle. It is required
		-- for the area and size check:
		b : type_area;
		
	begin
		-- Move the circle to the given position:
		move_circle (c, pos);
		
		-- Get the bounding-box of circle:
		b := get_bounding_box (c);
		-- put_line ("b " & to_string (b));
		
		-- Do the area check. If the bounding-box of the circle
		-- is inside the visible area then draw the circle. Otherwise
		-- nothing will be drawn:
		if areas_overlap (visible_area, b) and then

			-- Do the size check. If the bounding-box is greater
			-- (either in width or heigth) than the visiblity threshold
			-- then draw the line. Otherwise nothing will be drawn:
			above_visibility_threshold (b) then

			-- put_line ("draw circle");

			set_line_width (context, to_gdouble (to_distance (circle.w)));

			m := to_canvas (c.c, S, real => true);
			r := to_distance (c.r);

			-- This draw operation consumes the most time:
			arc (context, 
				 to_gdouble (m.x), 
				 to_gdouble (m.y),
				 to_gdouble (r), 
				 0.0, 6.3 ); -- start and end angle in radians
			
			stroke (context);
		end if;
	end draw_circle;
		
	
end demo_primitive_draw_ops;

