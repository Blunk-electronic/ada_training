------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                               BUTTONS                                    --
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

with glib;						use glib;
with gtk.box;					use gtk.box;
with demo_main_window;			use demo_main_window;


package body demo_buttons is

	procedure create_buttons is begin
		put_line ("create_buttons");
		
		gtk_new_vbox (box_v0);
		box_h.pack_start (box_v0, expand => false);


		gtk_new (buttons_table, rows => 5, columns => 1, 
			homogeneous => false);
		-- table.set_col_spacings (50);
		-- table_coordinates.set_border_width (10);


		gtk_new (button_zoom_fit, "ZOOM FIT");
		gtk_new (button_zoom_area, "ZOOM AREA");
		gtk_new (button_add, "ADD");
		gtk_new (button_delete, "DELETE");
		gtk_new (button_move, "MOVE");
		gtk_new (button_export, "EXPORT");
		-- CS add other buttons
		

		
		-- The table shall not expand downward:
		box_v0.pack_start (buttons_table, expand => false);

		
		buttons_table.attach (button_zoom_fit,
			left_attach => 0, right_attach => 1,
			top_attach  => 0, bottom_attach => 1);

		buttons_table.attach (button_zoom_area,
			left_attach => 0, right_attach => 1,
			top_attach  => 1, bottom_attach => 2);
		
		buttons_table.attach (button_add,
			left_attach => 0, right_attach => 1,
			top_attach  => 2, bottom_attach => 3);

		buttons_table.attach (button_delete,
			left_attach => 0, right_attach => 1,
			top_attach  => 3, bottom_attach => 4);

		buttons_table.attach (button_move,
			left_attach => 0, right_attach => 1,
			top_attach  => 4, bottom_attach => 5);

		buttons_table.attach (button_export,
			left_attach => 0, right_attach => 1,
			top_attach  => 5, bottom_attach => 6);
		
		
	end create_buttons;	
	
end demo_buttons;

