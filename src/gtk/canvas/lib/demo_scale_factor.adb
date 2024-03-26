------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                              SCALE FACTOR                                --
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


package body demo_scale_factor is

	procedure dummy is begin null; end;

-- 	function to_string (
-- 		scale : in type_scale_factor)
-- 		return string
-- 	is begin
-- 		return type_scale_factor'image (scale);
-- 	end to_string;
-- 	
-- 	
-- 	procedure increase_scale is begin
-- 		S := S * SM;
-- 		
-- 		exception 
-- 			when constraint_error =>
-- 				put_line ("upper scale limit reached");
-- 			when others => null;
-- 	end increase_scale;
-- 
-- 	
-- 	procedure decrease_scale is begin
-- 		S := S / SM;
-- 		
-- 		exception 
-- 			when constraint_error => 
-- 				put_line ("lower scale limit reached");
-- 			when others => null;
-- 	end decrease_scale;

	
end demo_scale_factor;

