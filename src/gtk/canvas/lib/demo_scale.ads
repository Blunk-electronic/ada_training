------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                                SCALE                                     --
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

with demo_geometry;				use demo_geometry;

package demo_scale is

	type type_scale is digits 3 range 0.10 .. 100.0;

	-- This is the global scale:
	M : type_scale := 1.0;

	-- Examples for usage:
	-- 1)
	-- If M is set to 10 then the scale is 1:10 (in words one to ten).
	-- This means: A distance of 1mm in the model represents
	-- a distance of 10mm in the real world.
	-- The drawing shows the reality enlarged.
	
	-- 2)
	-- If M is set to 0.1 then the scale is 10:1 (in words ten to one).
	-- This means: A distance of 10mm in the model represents
	-- a distance of 1mm in the real world. 
	-- The drawing shows the reality downsized.

	
	
	-- Converts the given scale factor to a string.
	-- CS: Since type_scale_factor is a float type, the output is
	-- something like 1.44E+00. Instead the output should be something
	-- simpler like 1.44:
	function to_string (
		scale : in type_scale)
		return string;

	
	-- Converts a distance of the model to a distance 
	-- in reality:
	function to_reality (
		d : in type_distance_model)
		return type_distance_model;

	
	-- Converts a distance of the reality to
	-- a distance in the model:
	function to_model (
		d : in type_distance_model)
		return type_distance_model;

	
end demo_scale;

