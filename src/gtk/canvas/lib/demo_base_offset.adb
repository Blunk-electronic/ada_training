------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                              BASE OFFSET                                 --
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
with demo_logical_pixels;		use demo_logical_pixels;
with demo_bounding_box;			use demo_bounding_box;
with demo_canvas;				use demo_canvas;
with demo_zoom;					use demo_zoom;

package body demo_base_offset is


	procedure set_base_offset is
		debug : boolean := false;
		
		x, y : type_logical_pixels;

		-- The maximum zoom factor:
		S_max : constant type_logical_pixels := 
			type_logical_pixels (type_zoom_factor'last);

		-- The width and height of the bounding-box:
		Bh : constant type_logical_pixels := 
			type_logical_pixels (bounding_box.height);
		
		Bw : constant type_logical_pixels := 
			type_logical_pixels (bounding_box.width);
		
	begin
		x :=   Bw * (S_max - 1.0);
		y := - Bh * S_max;

		-- Set the base-offset:
		F := (x, y);

		-- Output a warning if the base-offset is outside
		-- the canvas dimensions:
		if  x >   type_logical_pixels (canvas_size.width) or
			y < - type_logical_pixels (canvas_size.height) then

			put_line ("WARNING: base-offset outside canvas !");
			put_line (" F: " & to_string (F));
		end if;
		

		if debug then
			put_line ("base offset: " & to_string (F));
		end if;
	end set_base_offset;
	

end demo_base_offset;

