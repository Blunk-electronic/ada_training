-- This program demonstrates a drawing area - a so called 
-- canvas (german: Leinwand) inside a scrolled window.
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

with ada.text_io;				use ada.text_io;
with callbacks;					use callbacks;
with geometry;					use geometry;

procedure draw is

begin
	-- Create a dummy object that is to be displayed:
	make_object;
	-- NOTE: A real project should provide all objects in
	-- some kind of database.
	
	compute_bounding_box;
	compute_base_offset;
	prepare_initial_scrollbar_settings;

	
	init; -- inits the GTK-stuff

	set_up_main_window;

	set_up_swin_and_scrollbars;

	set_up_canvas;


	
	-- Add the canvas as a child to the scrolled window:
	put_line ("add canvas to scrolled window");
	swin.add (canvas); 
	-- swin.set_propagate_natural_height (true);
	
	-- Add the scrolled window as a child to the main window:
	put_line ("add scrolled window to main window");
	main_window.add (swin);

	put_line ("show all widgets");
	main_window.show_all;

	apply_initial_scrollbar_settings;

	put_line ("start gtk main loop");
	gtk.main.main;
end draw;

