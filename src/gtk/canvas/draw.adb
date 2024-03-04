---------------------------------------------------------------------------
--                                                                       --
--                              DEMO CANVAS                              --
--                                                                       --
--                               B o d y                                 --
--                                                                       --
-- Copyright (C) 2024                                                    --
-- Mario Blunk / Blunk electronic                                        --
-- Buchfinkenweg 3 / 99097 Erfurt / Germany                              --
--                                                                       --
-- This program is free software: you can redistribute it and/or modify  --
-- it under the terms of the GNU General Public License as published by  --
-- the Free Software Foundation, either version 3 of the License, or     --
-- (at your option) any later version.                                   --
--                                                                       --
-- This program is distributed in the hope that it will be useful,       --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of        --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         --
-- GNU General Public License for more details.                          --
--                                                                       --
-- You should have received a copy of the GNU General Public License     --
-- along with this program.  If not, see <http://www.gnu.org/licenses/>. --
---------------------------------------------------------------------------

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

-- This program demonstrates a drawing area - a so called 
-- canvas (german: Leinwand, Zeichenflaeche) inside a scrolled window.
-- In this example we distinguish between canvas-coordinates
-- and real-world-model-coordinates.

-- A simple zoom-in/out-at-mouse-pointer solution is provided here.

-- In this world the real-world coordinates have the y-axis going
-- upwards !

-- Signals emitted by the canvas are output on the 
-- console so that the user can watch how callback
-- procedures and functions are called.

-- build with command "gprbuild"
-- clean up with command "gprclean"

with glib;						use glib;
with gdk.event;					use gdk.event;
with gtk.main;					use gtk.main;
with gtk.widget;				use gtk.widget;
with gtk.adjustment;			use gtk.adjustment;
with gtk.window;				use gtk.window;
with gtk.enums;					use gtk.enums;
with gtk.scrolled_window;		use gtk.scrolled_window;
with gtk.drawing_area;			use gtk.drawing_area;
with gtk.box;					use gtk.box;
with gtk.separator;				use gtk.separator;
with ada.text_io;				use ada.text_io;
with callbacks;					use callbacks;
with geometry_1;				use geometry_1;
with geometry_2;
with demo_objects;
with demo_frame;
with demo_bounding_box;
with demo_canvas;
with demo_base_offset;
with demo_main_window;
with demo_scrolled_window;
with demo_visible_area;
with demo_coordinates_display;

procedure draw is

begin

	-- Generate a simple drawing frame:
	demo_frame.make_drawing_frame;

	-- Generate a database with some useless dummy
	-- objects:
	demo_objects.make_database;

	-- Compute the maximal dimensions of the canvas:
	demo_canvas.compute_canvas_size;

	-- Compute the initial bounding-box:
	demo_bounding_box.compute_bounding_box;

	-- Compute the base-offset F:
	demo_base_offset.set_base_offset;

	
	init; -- inits the GTK-stuff


	set_up_main_window; -- incl. box_h, box_v1, separator, box_v2
	
	demo_coordinates_display.set_up_coordinates_display; -- table in box_v1
	
	set_up_swin_and_scrollbars;
	set_up_canvas;
		

	put_line ("show all widgets");
	demo_main_window.main_window.show_all; -- assigns the allocation to the canvas

	
	demo_scrolled_window.set_initial_scrollbar_settings;

	-- show_adjustments_v;
	-- show_adjustments_h;

	update_scale_display;
	update_grid_display;

	-- On startup the canvas has the focus. This enables the operator
	-- to move the cursor with the cursor-keys from the beginning:
	demo_canvas.canvas.grab_focus;

	
	-- Zoom so that all objects are visible:
	zoom_to_fit (demo_bounding_box.bounding_box);

	
	-- Backup the currently visible area.
	-- This is relevant for canvas mode MODE_3_ZOOM_FIT only:
	demo_visible_area.backup_visible_area (demo_bounding_box.bounding_box);
	
	put_line ("start gtk main loop");

	gtk.main.main;
end draw;

