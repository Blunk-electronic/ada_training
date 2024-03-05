------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                              VISIBILITY                                  --
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

with glib;						use glib;

with geometry_1;				use geometry_1;
with geometry_2;				use geometry_2;
with demo_conversions;			use demo_conversions;


package body demo_visibility is

	
	function above_visibility_threshold (
		a : in type_area)
		return boolean
	is
		-- CS: Optimization required. Compiler options ?
		w : constant gdouble := to_distance (a.width);
		h : constant gdouble := to_distance (a.height);
		l : gdouble;
	begin
		-- Get the greatest of w and h:
		l := gdouble'max (w, h);

		if l > visibility_threshold then
			return true;
		else
			return false;
		end if;
		
	end above_visibility_threshold;

	
end demo_visibility;
