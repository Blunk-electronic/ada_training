------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                             DRAWING ORIGIN                               --
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

with cairo;
with demo_canvas;
with demo_scale_factor;
with demo_conversions;
with demo_geometry;				use demo_geometry;


package body demo_drawing_origin is

	
	procedure draw_origin is
		use cairo;
		use demo_canvas;
		use demo_scale_factor;
		use demo_conversions;
		
		cp : type_logical_pixels_vector := to_canvas (origin, S, true);
	begin
		set_source_rgb (context, 0.5, 0.5, 0.5); -- gray
		set_line_width (context, to_gdouble (origin_linewidth));

		-- Draw the horizontal line from left to right:
		move_to (context, 
			to_gdouble (cp.x - origin_size), to_gdouble (cp.y));
		
		line_to (context, 
			to_gdouble (cp.x + origin_size), to_gdouble (cp.y));

		-- Draw the vertical line from top to bottom:
		move_to (context, 
			to_gdouble (cp.x), to_gdouble (cp.y - origin_size));
		
		line_to (context, 
				to_gdouble (cp.x), to_gdouble (cp.y + origin_size));
		
		stroke;
	end draw_origin;


	
end demo_drawing_origin;

