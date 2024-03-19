------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                            LOGICAL PIXELS                                --
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


package body demo_logical_pixels is

	function to_string (
		lp : in type_logical_pixels)
		return string
	is begin
		return type_logical_pixels'image (lp);
	end to_string;

	

	function to_lp (
		gd : in glib.gdouble)
		return type_logical_pixels
	is begin
		return type_logical_pixels (gd);
	end to_lp;

	
	function to_gdouble (
		lp : in type_logical_pixels)
		return glib.gdouble
	is begin
		return glib.gdouble (lp);
	end to_gdouble;

	
	
	function to_string (
		v : in type_logical_pixels_vector)
		return string
	is begin
		--return "vector logical pixels x/y: "
		return to_string (v.x) & "/" 
			& to_string (v.y);
	end to_string;

	
	
	procedure clip_max (
		value	: in out type_logical_pixels;
		limit	: in type_logical_pixels)
	is begin
		if value > limit then
			value := limit;
		end if;
	end clip_max;
	
	
	procedure clip_min (
		value	: in out type_logical_pixels;
		limit	: in type_logical_pixels)
	is begin
		if value < limit then
			value := limit;
		end if;
	end clip_min;

	
end demo_logical_pixels;

