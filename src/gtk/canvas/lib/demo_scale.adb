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

with ada.strings.bounded;
with ada.strings;
with ada.strings.fixed;


package body demo_scale is

	function to_string (
		scale : in type_scale)
		return string
	is 
		use pac_scale_io;
		use ada.strings.bounded;
		use ada.strings;
		use ada.strings.fixed;

		package pac_scale_bounded is new generic_bounded_length (10);
		use pac_scale_bounded;
		
		m_bounded : pac_scale_bounded.bounded_string;

		-- This string holds temporarily the given scale.
		-- The length of the string should be set in advance
		-- here in order to take the longest possible combination
		-- of charecters according to the declaration of type_scale.
		-- Mind, the comma/point. It must also taken into account here:
		m_fixed : string (1 .. type_scale'digits + 3);
		-- CS find something more elegantly here.

		m_reciprocal : type_scale;
	begin
		--put_line ("scale" & type_scale'image (scale));

		-- Since we want an output like 1:100 or 100:1 the given scale
		-- must be checked whether it is greater or less than 1.0:
		if scale >= 1.0 then

			-- Output the given scale to a fixed string
			-- without an exponent:
			put (
				to		=> m_fixed, -- like 100.00
				item	=> scale,
				exp		=> 0); -- no exponent

			-- Trim the string on both ends and store it in m_bounded:
			m_bounded := trim (to_bounded_string (m_fixed), both);
			-- CS remove leading zeroes after the comma.

			-- Return a nicely formatted expression like 1:100
			return "1:" & to_string (m_bounded);
		else
			-- The scale is smaller than 1.0. So we first 
			-- calculate the reciprocal of scale.
			-- For example: scale 0.01 turns to 100.0:
			m_reciprocal := 1.0 / scale;

			-- Output the given scale to a fixed string
			-- without an exponent:
			put (
				to		=> m_fixed, -- like 100.0
				item	=> m_reciprocal,
				exp		=> 0); -- no exponent

			-- Trim the string on both ends and store it in m_bounded:
			m_bounded := trim (to_bounded_string (m_fixed), both);
			-- CS remove leading zeroes after the comma.
			
			-- Return a nicely formatted expression like 100:1
			return to_string (m_bounded) & ":1";
		end if;
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

