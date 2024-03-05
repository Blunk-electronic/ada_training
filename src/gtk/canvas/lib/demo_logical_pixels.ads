------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                            LOGICAL PIXELS                                --
--                                                                          --
--                               S p e c                                    --
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

with glib;						use glib;

package demo_logical_pixels is


	
-- DISTANCE AND VECTORS ON THE SCREEN:

	-- GTK3 uses the type gdouble for primitive draw operations
	-- on the canvas. It also uses gdouble for scrollbar settings.
	-- A point, a vector or a distance is expressed in
	-- so called "logical pixels".	

	-- The total distance between two gdouble numbers is
	-- always positive. So we define the distance as:
	subtype type_distance_gdouble is gdouble range 0.0 .. gdouble'last;

	
	-- A point, a location vector or a distance vector is
	-- defined by this type:
	type type_vector_gdouble is record
		x, y : gdouble := 0.0;
	end record;


	-- This function outputs the x and y component of a vector
	-- on the console:
	function to_string (
		v : in type_vector_gdouble)
		return string;



	
	-- Clips the given value by the given limit.
	-- If the given value is less or equal the limit,
	-- then value remains unchanged:
	procedure clip_max (
		value	: in out gdouble;
		limit	: in gdouble);
	
	-- Clips the given value by the given limit.
	-- If the given value is greater or equal the limit,
	-- then value remains unchanged:
	procedure clip_min (
		value	: in out gdouble;
		limit	: in gdouble);

	
	
end demo_logical_pixels;
