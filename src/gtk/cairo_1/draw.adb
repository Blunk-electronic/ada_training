-- This program demonstrates the basics of a simple
-- drawing area - a so called canvas (german: Leinwand).
-- It draws a red rectangle in the upper left corner
-- as shown in image file draw.jpg.

-- build with command "gprbuild"
-- clean up with command "gprclean"

-- with gdk.event;
with gtk.main;					use gtk.main;
with gtk.widget;				use gtk.widget;
with gtk.window;				use gtk.window;
with gtk.enums;					--use gtk.enums;

with gtk.drawing_area;			use gtk.drawing_area;

with ada.text_io;				use ada.text_io;
with callbacks;					use callbacks;


procedure draw is

	window		: gtk_window;
	canvas		: gtk_drawing_area;

begin
	init;

	-- Set up the main window::
	window := gtk_window_new (gtk.enums.WINDOW_TOPLEVEL);
	window.set_title ("Canvas");
	window.set_border_width (10);
	-- window.set_size_request (300, 200);
	window.set_default_size (300, 200);
	window.on_destroy (cb_terminate'access);


	-- Set up the drawing area:
	gtk_new (canvas);
	-- canvas.add_events (gdk.event.button_press_mask);
	
	canvas.on_draw (cb_draw'access);
	-- NOTE: No context is declared here, because the canvas widget
	-- passes its own context to the callback procedure cb_draw.
	
	window.add (canvas);

	window.show_all;
	gtk.main.main;
end draw;

