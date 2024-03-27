------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                                SCALE                                     --
--                                                                          --
--                               B o d y                                    --
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


package body demo_scale is

	function to_string (
		scale : in type_scale)
		return string
	is begin
		return type_scale'image (scale);
	end to_string;


	function to_reality (
		d : in type_distance_model)
		return type_distance_model
	is begin
		return type_distance_model_positive (M) * d;
	end to_reality;


	procedure to_reality (
		d : in out type_distance_model)
	is begin
		d := type_distance_model_positive (M) * d;
	end to_reality;


	
	function to_model (
		d : in type_distance_model)
		return type_distance_model
	is begin
		return type_distance_model_positive (1.0 / M) * d;
	end to_model;

	procedure to_model (
		d : in out type_distance_model)
	is begin
		d := type_distance_model_positive (1.0 / M) * d;
	end to_model;

	

	function to_reality (
		v : in type_vector_model)
		return type_vector_model
	is begin
		return (x => to_reality (v.x), y => to_reality (v.y));
	end to_reality;

	
	function to_model (
		v : in type_vector_model)
		return type_vector_model
	is begin
		return (x => to_model (v.x), y => to_model (v.y));
	end to_model;


	
end demo_scale;

