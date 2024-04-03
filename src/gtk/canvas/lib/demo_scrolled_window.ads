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

with glib;						use glib;
with gtk.widget;				use gtk.widget;
with gtk.window;				use gtk.window;
with gtk.scrolled_window;		use gtk.scrolled_window;
with gtk.adjustment;			use gtk.adjustment;
with gtk.scrollbar;				use gtk.scrollbar;

with demo_logical_pixels;		use demo_logical_pixels;
with demo_geometry;				use demo_geometry;
with demo_zoom;					use demo_zoom;
with demo_window_dimensions;	use demo_window_dimensions;
with demo_conversions;			use demo_conversions;


package demo_scrolled_window is

-- SCROLLED WINDOW:

	swin : gtk_scrolled_window;

	-- Inside the scrolled window the canvas exists.


-- SCROLLBARS:
	
	scrollbar_h_adj, scrollbar_v_adj : gtk_adjustment;
	scrollbar_v, scrollbar_h : gtk_scrollbar;


	-- This composite type contains the settings
	-- of a scrollbar:
	type type_scrollbar_settings is record
		lower		: type_logical_pixels_positive;
		upper		: type_logical_pixels_positive;
		value		: type_logical_pixels_positive;
		page_size	: type_logical_pixels_positive;
	end record;

	-- These are the places where the initial settings of
	-- the scrollbars are stored:
	scrollbar_v_init : type_scrollbar_settings;
	scrollbar_h_init : type_scrollbar_settings;

	-- These are the places where we backup the settings of
	-- the scrollbars:
	scrollbar_h_backup, scrollbar_v_backup : type_scrollbar_settings;

	
	
	type type_scroll_direction is (
		SCROLL_UP,
		SCROLL_DOWN,
		SCROLL_RIGHT,
		SCROLL_LEFT);


	

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



	
	
	-- Creates the scrolled window and its scrollbars:
	procedure create_scrolled_window_and_scrollbars;



	-- This procedure does a backup of the current settings
	-- of both the horizontal and the vertical scrollbar:
	procedure backup_scrollbar_settings;


	-- This procedure restores the settings of the vertical
	-- and horizontal scrollbar from the backup:
	procedure restore_scrollbar_settings;



	-- Sets the initial scrollbar settings based on
	-- current base-offset and bounding-box:
	procedure set_initial_scrollbar_settings;
	
	
	-- For debugging, these procedures output the settings
	-- of the scrollbars on the console:
	procedure show_adjustments_v;
	procedure show_adjustments_h;


	-- This function calculates the zoom factor required to
	-- fit the given area into the current scrolled window.
	-- The scrolled window has an initial size on startup. Later, when
	-- the operator resizes the main window, the scrolled window gets
	-- larger or smaller. This results in a situation depended zoom factor:
	function get_ratio (
		area : in type_area)
		return type_zoom_factor;


	-- Updates the limits of the scrollbars.
	-- The argument C1 provides the old corners of the 
	-- bounding-box on the canvas and C2 the new corners:
	procedure update_scrollbar_limits (
		C1, C2 : in type_bounding_box_corners);

	
end demo_scrolled_window;

