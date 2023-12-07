------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                              GEOMETRY 2                                  --
--                                                                          --
--                               S p e c                                    --
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

-- with glib;						use glib;

with ada.numerics;
with ada.numerics.generic_elementary_functions;

with geometry_1;				use geometry_1;

package geometry_2 is

	procedure dummy;

	-- The simplest object in the model world is a line:
	type type_line is record
		s, e : type_point_model; -- start and end point
		w : type_distance_model; -- linewidth
	end record;


	-- CS arc ?

	type type_object is abstract tagged record
		p : type_point_model;
	end record;

	
	type type_rectangle is new type_object with record
		-- The four corners of the rectangle in
		-- counter-clockwise order:
		bl : type_point_model; -- bottom left
		br : type_point_model; -- bottom right
		tr : type_point_model; -- top right
		tl : type_point_model; -- top left
		w  : type_distance_model; -- the linewidth
	end record;
	

	-- Another primitive object is a circle:
	type type_circle is new type_object with record
		w : type_distance_model; -- the linewidth
		-- CS: fill status
	end record;


	type type_complex_object is new type_object with record
		l1, l2, l3 : type_line;
		c1 : type_circle;
	end record;


	object_1 : type_rectangle := (
		p	=> ( 20.0,  20.0),
		bl	=> (-10.0, -10.0),
		br	=> ( 10.0, -10.0),
		tr	=> ( 10.0,  10.0),
		tl	=> (-10.0,  20.0),
		w	=> 1.0);
	
end geometry_2;

