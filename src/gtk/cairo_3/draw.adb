-- This program demonstrates a drawing area - a so called 
-- canvas (german: Leinwand) inside a scrolled window.
-- It draws a red rectangle in the upper left corner
-- as shown in image file draw.jpg.

-- Signals emitted by the canvas are output on the 
-- console so that the user can watch how callback
-- procedures and functions are called.

-- build with command "gprbuild"
-- clean up with command "gprclean"

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


procedure draw is
	horizontal, vertical : gtk_adjustment;
begin
	init;

	-- Set up the main window::
	window := gtk_window_new (WINDOW_TOPLEVEL);
	window.set_title ("Canvas");
	window.set_border_width (10);
	-- window.set_size_request (300, 200);
	window.set_default_size (300, 200);
	window.on_destroy (cb_terminate'access);


	
	
	-- Create a scrolled window:
	swin := gtk_scrolled_window_new (hadjustment => null, vadjustment => null);
	horizontal := swin.get_hadjustment;
	vertical := swin.get_vadjustment;

	-- Connect the signal "value-changed" of the scrollbars with 
	-- procedures cb_vertical_moved and cb_horizontal_moved. So the user
	-- can watch how the signals are emitted:
	vertical.on_value_changed (cb_vertical_moved'access);
	horizontal.on_value_changed (cb_horizontal_moved'access);
	
	-- swin.set_border_width (5);

	swin.set_policy ( -- for scrollbars
		hscrollbar_policy => gtk.enums.POLICY_AUTOMATIC, 
		vscrollbar_policy => gtk.enums.POLICY_AUTOMATIC);


	
	
	-- Set up the drawing area:
	gtk_new (canvas);

	-- Set the size of the area required for all the objects
	-- to be drawn. This is the so called "bounding rectangle"
	-- around everything to be drawn. The size of the bounding
	-- rectangle MUST be known beforehand of calling the
	-- callback procedure cb_draw (see below):
	canvas.set_size_request (600, 200); -- unit is pixels
	
	canvas.on_draw (cb_draw'access);
	-- NOTE: No context is declared here, because the canvas widget
	-- passes its own context to the callback procedure cb_draw.


	
	-- Make the canvas responding to mouse button clicks:
	canvas.add_events (gdk.event.button_press_mask);
	canvas.on_button_press_event (cb_button_pressed'access);

	-- Make the canvas responding to mouse movement:
	canvas.add_events (gdk.event.pointer_motion_mask);
	canvas.on_motion_notify_event (cb_mouse_moved'access);

	-- Make the canvas responding to the mouse wheel:
	canvas.add_events (gdk.event.scroll_mask);
	canvas.on_scroll_event (cb_mouse_wheel_rolled'access);
	
	-- Make the canvas responding to the keyboard:
	canvas.set_can_focus (true);
	canvas.add_events (key_press_mask);
	canvas.on_key_press_event (cb_key_pressed'access);

	canvas.on_size_allocate (cb_size_allocate'access);

	
	-- Add the canvas as a child to the scrolled window:
	swin.add_with_viewport (canvas); 

	-- Add the scrolled window as a child to the main window:
	window.add (swin);

	window.show_all;
	gtk.main.main;
end draw;

