------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                              GEOMETRY 1                                  --
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

with glib;						use glib;

with ada.numerics;
with ada.numerics.generic_elementary_functions;

package geometry_1 is



-- SCALE:

	type type_scale_factor is digits 3 range 0.10 .. 10.0;
	scale_factor : type_scale_factor := 1.0;
	scale_multiplier : constant type_scale_factor := 1.2;


	-- Converts the given scale factor to a string.
	-- CS: Since type_scale_factor is a float type, the output is
	-- something like 1.44E+00. Instead the output should be something
	-- simpler like 1.44:
	function to_string (
		scale : in type_scale_factor)
		return string;
	
	procedure increase_scale;
	procedure decrease_scale;

	

	
-- INTERNAL FLOAT TYPE:

	-- This float type is used for internal computations only:
	type type_float is new float; -- CS refinement required

	
	package pac_float_numbers_functions is new 
		ada.numerics.generic_elementary_functions (type_float);
	
	



	
-- CANVAS:

	subtype type_distance_canvas is gdouble range 0.0 .. gdouble'last;
	
	type type_point_canvas is record
		x, y : gdouble := 0.0;
	end record;

		
	function to_string (
		point	: in type_point_canvas)
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

	
	
end geometry_1;

