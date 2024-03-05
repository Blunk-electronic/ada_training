------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                              MAIN WINDOW                                 --
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

with gtk.enums;					use gtk.enums;


package body demo_main_window is

	
	procedure create_window is begin
		put_line ("create_window");
		

		main_window := gtk_window_new (WINDOW_TOPLEVEL);
		main_window.set_title ("Demo Canvas");
		main_window.set_border_width (10);

		-- CS: Set the minimum size of the main window ?
		-- CS show main window size
		-- main_window.set_size_request (1000, 500);

		-- main_window.set_redraw_on_allocate (false);
		

		gtk_new_hbox (box_h);

		
		-- vertical box for coordinates display:
		gtk_new_vbox (box_v1);
		box_v1.set_border_width (10);
		
		-- The left vbox shall not change its width when the 
		-- main window is resized:
		box_h.pack_start (box_v1, expand => false);

		-- Place a separator between the left and right
		-- vertical box:
		separator := gtk_separator_new (ORIENTATION_VERTICAL);
		box_h.pack_start (separator, expand => false);

		-- The right vbox shall expand upon resizing the main window:
		-- box_h.pack_start (box_v2);

		main_window.add (box_h);
		
	end create_window;

	
end demo_main_window;

