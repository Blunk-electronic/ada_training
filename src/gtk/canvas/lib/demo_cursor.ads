------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                                CURSOR                                    --
--                                                                          --
--                                S p e c                                   --
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

with demo_logical_pixels;		use demo_logical_pixels;
with demo_geometry;				use demo_geometry;


package demo_cursor is

	-- The cursor is a crosshair that can be moved by the
	-- cursor keys (arrow keys) about the canvas:
	type type_cursor is record
		position	: type_vector_model := origin;

		-- For drawing the cursor:
		linewidth_1	: type_logical_pixels_positive := 1.0;
		linewidth_2	: type_logical_pixels_positive := 4.0;
		length_1	: type_logical_pixels_positive := 20.0;
		length_2	: type_logical_pixels_positive := 20.0;
		radius		: type_logical_pixels_positive := 25.0;
		
		-- CS: blink, color, ...
	end record;

	
	-- This is the instance of the cursor:
	cursor : type_cursor;


	-- This procedure moves the cursor to the given destination:
	procedure move_cursor (
		destination : type_vector_model);


	-- This procedure moves the cursor into the given direction:
	procedure move_cursor (
		direction : type_direction);


	-- This procedure draws the cursor at its current
	-- position. To keep things simple, the cursor is
	-- drawn always, regardless whether it is in the visible
	-- area or not:
	procedure draw_cursor;

	
end demo_cursor;

