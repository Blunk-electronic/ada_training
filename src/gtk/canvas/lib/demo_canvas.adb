------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                                CANVAS                                    --
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

with gdk.event;
with glib;
with ada.text_io;				use ada.text_io;

with demo_main_window;
with demo_scrolled_window;
with demo_bounding_box;
with demo_zoom;					use demo_zoom;


package body demo_canvas is

	procedure stroke is begin
		cairo.stroke (context);
	end stroke;

	
	procedure refresh (
		canvas	: access gtk_widget_record'class)
	is
		drawing_area : constant gtk_drawing_area := 
			gtk_drawing_area (canvas);
	begin
		-- put_line ("refresh " & image (clock)); 
		drawing_area.queue_draw;
	end refresh;


	procedure compute_canvas_size is
		use demo_logical_pixels;
		use demo_bounding_box;
		
		debug : boolean := true;

		-- The maximal base-offset:
		F_max : type_logical_pixels_vector;
		
		-- The maximum zoom factor:
		S_max : constant type_logical_pixels := 
			type_logical_pixels (type_zoom_factor'last);

		-- The maximum width and height of the bounding-box:
		Bw : constant type_logical_pixels := 
			type_logical_pixels (bounding_box_width_max);
		
		Bh : constant type_logical_pixels := 
			type_logical_pixels (bounding_box_height_max);
	begin
		if debug then
			put_line ("compute_canvas_size");
			put_line (" S_max : " & to_string (S_max));
			put_line (" Bw_max: " & to_string (Bw));
			put_line (" Bh_max: " & to_string (Bh));
		end if;

		-- compute the maximal base-offset:
		F_max.x :=   Bw * (S_max - 1.0);
		F_max.y := - Bh * S_max;

		if debug then
			put_line (" F_max : " & to_string (F_max));
		end if;

		-- compute the canvas width and height:
		canvas_size.width  := positive (  F_max.x + Bw * S_max);
		canvas_size.height := positive (- F_max.y + Bh * (S_max - 1.0));

		if debug then
			put_line (" Cw    : " & positive'image (canvas_size.width));
			put_line (" Ch    : " & positive'image (canvas_size.height));
		end if;
	end compute_canvas_size;



	
	procedure show_canvas_size is 
		use glib;
		a : gtk_allocation;
		width, height : gint;
	begin
		canvas.get_allocation (a);
		put_line ("canvas size allocated (w/h):" 
			& gint'image (a.width) & " /" & gint'image (a.height));
		
		canvas.get_size_request (width, height);
		put_line ("canvas size minimum   (w/h):" 
			& gint'image (width) & " /" & gint'image (height));
	end show_canvas_size;

	

	procedure create_canvas is
		use demo_main_window;
		use demo_scrolled_window;
		use gdk.event;
		use glib;
	begin
		-- Set up the drawing area:
		gtk_new (canvas);

		-- Set the size (width and height) of the canvas:
		canvas.set_size_request (
			gint (canvas_size.width), gint (canvas_size.height));
		
		show_canvas_size;

		-- Make the canvas responding to mouse button clicks:
		canvas.add_events (gdk.event.button_press_mask);
		canvas.add_events (gdk.event.button_release_mask);

		-- Make the canvas responding to mouse movement:
		canvas.add_events (gdk.event.pointer_motion_mask);

		-- Make the canvas responding to the mouse wheel:
		canvas.add_events (gdk.event.scroll_mask);

		-- Make the canvas responding to the keyboard:
		canvas.set_can_focus (true);
		canvas.add_events (key_press_mask);

		
		-- Add the canvas as a child to the scrolled window:
		put_line ("add canvas to scrolled window");
		swin.add (canvas); 

		-- Insert the scrolled window in box_h:
		put_line ("add scrolled window to box_h");
		box_h.pack_start (swin);
		
	end create_canvas;



	procedure shift_canvas (
		direction	: type_direction;
		distance	: type_distance_model)
	is
		use demo_scrolled_window;
		
		-- Convert the given model distance to 
		-- a canvas distance:
		d : constant type_logical_pixels := 
			type_logical_pixels (distance) * type_logical_pixels (S);

		-- Scratch values for upper limit, lower limit and value
		-- of scrollbars:
		u, l, v : type_logical_pixels;
	begin
		case direction is
			when DIR_RIGHT =>
				-- Get the maximal allowed value for the
				-- horizontal scrollbar:
				u := to_lp (scrollbar_h_adj.get_upper);

				-- Compute the required scrollbar position:
				v := to_lp (scrollbar_h_adj.get_value) + d;

				-- Clip the required position if necesary,
				-- then apply it to the scrollbar:
				clip_max (v, u);
				scrollbar_h_adj.set_value (to_gdouble (v));

				
			when DIR_LEFT =>
				-- Get the minimal allowed value for the
				-- horizontal scrollbar:
				l := to_lp (scrollbar_h_adj.get_lower);

				-- Compute the required scrollbar position:
				v := to_lp (scrollbar_h_adj.get_value) - d;

				-- Clip the required position if necesary,
				-- then apply it to the scrollbar:
				clip_min (v, l);
				scrollbar_h_adj.set_value (to_gdouble (v));

				
			when DIR_UP =>
				-- Get the minimal allowed value for the
				-- vertical scrollbar:
				l := to_lp (scrollbar_v_adj.get_lower);
				
				-- Compute the required scrollbar position:
				v := to_lp (scrollbar_v_adj.get_value) - d;

				-- Clip the required position if necesary,
				-- then apply it to the scrollbar:
				clip_min (v, l);
				scrollbar_v_adj.set_value (to_gdouble (v));

				
			when DIR_DOWN =>
				-- Get the maximal allowed value for the
				-- vertical scrollbar:
				u := to_lp (scrollbar_v_adj.get_upper);

				-- Compute the required scrollbar position:
				v := to_lp (scrollbar_v_adj.get_value) + d;

				-- Clip the required position if necesary,
				-- then apply it to the scrollbar:
				clip_max (v, u);
				scrollbar_v_adj.set_value (to_gdouble (v));
				
		end case;

		backup_scrollbar_settings;
	end shift_canvas;

	
end demo_canvas;

