------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                                 ZOOM                                     --
--                                                                          --
--                                B o d y                                   --
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

with demo_base_offset;			use demo_base_offset;
with demo_translate_offset;		use demo_translate_offset;
with demo_conversions;			use demo_conversions;


package body demo_zoom is


	procedure set_translation_for_zoom (
		S1	: in type_scale_factor;
		S2	: in type_scale_factor;
		Z1	: in type_vector_gdouble)
	is 
		debug : boolean := false;
		
		-- Compute the virtual model-point
		-- according to the scale factor before zoom:
		M : constant type_vector_model := to_model (Z1, S1);

		Z2 : type_vector_gdouble;
	begin			
		if debug then
			put_line ("set_translation_for_zoom");
		end if;
		
		-- Compute the prospected canvas-point according to the 
		-- scale factor after zoom:
		Z2 := to_canvas (M, S2);

		-- This is the offset from Z1 to the prospected
		-- point Z2. The offset must be multiplied by -1 because the
		-- drawing must be dragged-back to the given pointer position:
		T.x := -(Z2.x - Z1.x);
		T.y := -(Z2.y - Z1.y);

		if debug then
			put_line (" T: " & to_string (T));
		end if;
	end set_translation_for_zoom;


	

	procedure set_translation_for_zoom (
		S1	: in type_scale_factor;
		S2	: in type_scale_factor;
		M	: in type_vector_model) -- real model point
	is 
		debug : boolean := false;
		
		-- Compute the canvas point corresponding to the given
		-- real model point with the scale factor before zoom:
		Z1 : constant type_vector_gdouble := to_canvas (M, S1, real => true);

		-- Convert the given model point to a virtual point in the model:
		V : constant type_vector_model := to_virtual (M);
		
		Z2 : type_vector_gdouble;
	begin			
		if debug then
			put_line ("set_translation_for_zoom");
		end if;
		
		-- Compute the prospected canvas-point according to the 
		-- scale factor after zoom:
		Z2 := to_canvas (V, S2);
		-- put_line ("Z2 " & to_string (Z2));

		-- This is the offset from point Z1 to the prospected
		-- point Z2. The offset must be multiplied by -1 because the
		-- drawing must be dragged-back to the given pointer position:
		T.x := -(Z2.x - Z1.x);
		T.y := -(Z2.y - Z1.y);
		
		if debug then
			put_line (" T: " & to_string (T));
		end if;
	end set_translation_for_zoom;



	procedure reset_zoom_area is begin
		put_line ("reset_zoom_area");
		zoom_area := (others => <>);
	end reset_zoom_area;

	
end demo_zoom;

