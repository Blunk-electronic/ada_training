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

with geometry_1;				use geometry_1;
with demo_conversions;			use demo_conversions;
with demo_visible_area;			use demo_visible_area;
with demo_visibility;			use demo_visibility;


package body demo_primitive_draw_ops is

	procedure draw_line (
		context	: in cairo_context; -- CS make context global ?
		line	: in type_line;
		pos		: in type_vector_model)
	is
		
		-- CS: Optimization required. Compiler options ?
		
		-- Make a copy of the given line:
		l : type_line := line;

		-- When the line is drawn, we need canvas points
		-- for start and end:
		c1, c2 : type_vector_gdouble; -- start and end of the line

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

			set_line_width (context, to_distance (line.w));

			c1 := to_canvas (l.s, S, real => true);
			c2 := to_canvas (l.e, S, real => true);
			move_to (context, c1.x, c1.y);
			line_to (context, c2.x, c2.y);
			stroke (context);
		end if;
	end draw_line;

	
	procedure draw_circle (
		context	: in cairo_context; -- CS make context global ?
		circle	: in type_circle;
		pos		: in type_vector_model) -- the position of the complex object
	is
	
		-- CS: Optimization required. Compiler options ?
		
		-- Make a copy of the given circle:
		c : type_circle := circle;

		-- When the circle is drawn, we need a canvas point
		-- for the center:
		m : type_vector_gdouble;

		r : type_distance_gdouble;
		
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

			set_line_width (context, to_distance (circle.w));

			m := to_canvas (c.c, S, real => true);
			r := to_distance (c.r);
			arc (context, m.x, m.y, r, 0.0, 6.3 );
			stroke (context);
		end if;
	end draw_circle;
	

	
	
end demo_primitive_draw_ops;

