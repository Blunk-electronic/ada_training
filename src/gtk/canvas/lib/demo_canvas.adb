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

with glib;						use glib;
with gdk.event;

with ada.text_io;				use ada.text_io;

with demo_main_window;
with demo_scrolled_window;



package body demo_canvas is

	procedure refresh (
		canvas	: access gtk_widget_record'class)
	is
		drawing_area : constant gtk_drawing_area := gtk_drawing_area (canvas);
	begin
		-- put_line ("refresh " & image (clock)); 
		drawing_area.queue_draw;
	end refresh;



	procedure show_canvas_size is 
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
	begin
		-- Set up the drawing area:
		gtk_new (canvas);

		-- Set the size (width and height) of the canvas:
		canvas.set_size_request (gint (canvas_size.width), gint (canvas_size.height));
		
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

	
end demo_canvas;

