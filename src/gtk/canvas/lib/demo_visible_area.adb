------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                             VISIBLE AREA                                 --
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

with gtk.scrolled_window;		use gtk.scrolled_window;

with demo_logical_pixels;		use demo_logical_pixels;
with demo_translate_offset;		use demo_translate_offset;
with demo_zoom;					use demo_zoom;
with demo_conversions;			use demo_conversions;
with demo_scrolled_window;		use demo_scrolled_window;
with demo_canvas;				use demo_canvas;


package body demo_visible_area is


	function get_visible_area (
		canvas	: access gtk_widget_record'class)
		return type_area
	is
		result : type_area;

		-- The allocation of the scrolled window:
		W : gtk_allocation;
		
		h_start, h_length, h_end : type_logical_pixels;
		v_start, v_length, v_end : type_logical_pixels;

		-- The four corners of the visible area:
		BL, BR, TL, TR : type_vector_model;
	begin
		-- Inquire the allocation of the scrolled window
		-- inside the main window:
		get_allocation (swin, W);

		
		-- X-AXIS:
		
		-- The visible area along the x-axis starts at the
		-- position of the horizontal scrollbar:
		h_start  := to_lp (scrollbar_h_adj.get_value);

		-- The visible area along the x-axis is as wide as
		-- the scrolled window:
		h_length := type_logical_pixels (W.width);

		-- The visible area ends here:
		h_end    := h_start + h_length;


		-- Y-AXIS:
		
		-- The visible area along the y-axis starts at the
		-- position of the vertical scrollbar:
		v_start := to_lp (scrollbar_v_adj.get_value);

		-- The visible area along the y-axis is as high as
		-- the scrolled window:
		v_length := type_logical_pixels (W.height);

		-- The visible area along the y-axis ends here:
		v_end := v_start + v_length;

		
		-- Compute the corners of the visible area.
		-- The corners are real model coordinates:
		BL := canvas_to_real ((h_start, v_end),   S);
		BR := canvas_to_real ((h_end, v_end),     S);
		TL := canvas_to_real ((h_start, v_start), S);
		TR := canvas_to_real ((h_end, v_start),   S);

		-- put_line ("BL " & to_string (BL));
		-- put_line ("BR " & to_string (BR));
		-- put_line ("TR " & to_string (TR));
		-- put_line ("TL " & to_string (TL));

		-- The position of the visible area is the lower left 
		-- corner:
		result.position := BL;
		
		-- Compute the width and the height of the
		-- visible area:
		result.width := TR.x - TL.x;
		result.height := TL.y - BL.y;

		-- CS: more effective ?
		-- result.width    := type_distance_model 
		--		(h_length) * type_distance_model (S);
		-- result.height   := type_distance_model 
		--		(v_length) * type_distance_model (S);

		-- put_line ("visible area " & to_string (result));
		return result;
	end get_visible_area;



	procedure center_to_visible_area (
		area : in type_area)
	is
		-- debug : boolean := true;
		debug : boolean := false;
		
		-- The offset required to "move" all objects into
		-- the center of the visible area:
		dx, dy : type_distance_model;
		
		-- Get the currently visible model area:
		v : constant type_area := get_visible_area (canvas);

		w1 : constant type_distance_model := v.width;
		w2 : constant type_distance_model := area.width;

		h1 : constant type_distance_model := v.height;
		h2 : constant type_distance_model := area.height;

		a, b : type_distance_model;

		x0 : constant type_distance_model := area.position.x;
		y0 : constant type_distance_model := area.position.y;
		
		x1 : constant type_distance_model := v.position.x;
		y1 : constant type_distance_model := v.position.y;

		-- The given area will end up at this target position:
		x2, y2 : type_distance_model;
		
	begin
		if debug then
			put_line ("given   " & to_string (area));
			put_line ("visible " & to_string (v));
		end if;
		
		a := (w1 - w2) * 0.5;
		x2 := x1 + a;
		dx := x2 - x0;

		b := (h1 - h2) * 0.5;
		y2 := y1 + b;
		dy := y2 - y0;

		if debug then
			put_line ("dx:" & to_string (dx));
			put_line ("dy:" & to_string (dy));
		end if;

		-- Convert the model offset (dx;dy) to a canvas offset
		-- and apply it to the global translate-offset.
		-- Regarding y: T is in the canvas system (CS2)
		-- where the y-axis goes downward. So we must multiply by -1:
		T.x :=   type_logical_pixels (dx) * type_logical_pixels (S);
		T.y := - type_logical_pixels (dy) * type_logical_pixels (S);
		if debug then
			put_line ("T: " & to_string (T));
		end if;

	end center_to_visible_area;


	
	procedure backup_visible_area (
		area : in type_area)
	is begin
		last_visible_area := area;
	end backup_visible_area;
	

end demo_visible_area;

