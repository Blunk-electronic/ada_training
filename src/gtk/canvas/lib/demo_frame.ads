------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                             DRAWING FRAME                                --
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

with demo_geometry;				use demo_geometry;
with demo_objects;				use demo_objects;


package demo_frame is
	

	type type_drawing_frame is new type_object with record
		lines	: pac_lines.list;
		-- CS texts
		-- CS separate entry for title block elements
	end record;
	
	drawing_frame : type_drawing_frame;

	
	-- The place where the lower left corner of the 
	-- drawing frame relative to the origin is:
	drawing_frame_position : type_vector_model := (-150.0, -105.0);
	--drawing_frame_position : type_vector_model := (0.0, 0.0);


	-- This procedure generates a very simple
	-- dummy drawing frame:
	procedure make_drawing_frame;


	-- Draws all primitive objects of the drawing frame
	-- and draws them one by one:
	procedure draw_drawing_frame;
	
end demo_frame;

