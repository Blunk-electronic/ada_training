------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                         PRIMITIVE DRAW OPERATIONS                        --
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

with demo_geometry;			use demo_geometry;
with demo_objects;			use demo_objects;


package demo_primitive_draw_ops is
	
	-- This is a primitive draw operation that draws a line.
	-- The argument pos contains the position of the parent
	-- complex object.
	-- If the argument do_stroke is false (default) then
	-- no setting of linewidth and no stroking will be done. In this
	-- case it is assumed that the caller has already set a linewidth
	-- and that the caller will later care for a stroke command. This mode
	-- requires less time for drawing the line than with do_stroke enabled.
	procedure draw_line (
		line		: in type_line;
		pos			: in type_vector_model;
		do_stroke	: in boolean := false);

	
	-- This is a primitive draw operation that draws a circle.
	-- For arguments see draw_line:
	procedure draw_circle (
		circle		: in type_circle;
		pos			: in type_vector_model;
		do_stroke	: in boolean := false);
	
	
end demo_primitive_draw_ops;

