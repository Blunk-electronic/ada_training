------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                            SCROLLED WINDOW                               --
--                                                                          --
--                                S p e c                                   --
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

with gtk.widget;				use gtk.widget;
with gtk.window;				use gtk.window;
with gtk.scrolled_window;		use gtk.scrolled_window;

with demo_window_dimensions;	use demo_window_dimensions;


package demo_scrolled_window is

	-- This is the scrolled window:
	swin : gtk_scrolled_window;

	-- Inside the scrolled window the canvas exists.



	-- This is the initial size of the scrolled window.
	-- IMPORTANT: The height must be greater than the sum
	-- of the height of all other widgets in the main window !
	-- Otherwise the canvas may freeze and stop emitting signals.
	swin_size_initial : constant type_window_size := (
		width	=> 400,
		height	=> 400);
	
	-- The current size of the scrolled window. It gets updated
	-- in procedure set_up_swin_and_scrollbars and 
	-- in cb_swin_size_allocate. This variable is required
	-- in order to detect size changes of the scrolled window:
	swin_size : type_window_size;

	

	
	-- When the scrolled window is resized, then the canvas can
	-- operate in in several ways. Currently these modes are defined:
	type type_scrolled_window_zoom_mode is (
		-- No zoom. No moving. Just more or less of 
		-- the canvas area is exposed:
		MODE_1_EXPOSE_CANVAS,

		-- Center of visible canvas area remains in the center. 
		-- Around the center more or less of the canvas area is exposed:
		MODE_2_KEEP_CENTER,

		-- The visible area remains fit into the scrolled window.
		MODE_3_ZOOM_FIT);


	-- Here the zoom mode of the scrolled window is fixed:
	zoom_mode : constant type_scrolled_window_zoom_mode := 
		-- MODE_1_EXPOSE_CANVAS;
		-- MODE_2_KEEP_CENTER;
		MODE_3_ZOOM_FIT;

	
end demo_scrolled_window;

