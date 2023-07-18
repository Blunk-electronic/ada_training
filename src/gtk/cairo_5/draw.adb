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

	window		: gtk_window;
	-- swin		: gtk_scrolled_window;


begin
	init;

	-- Set up the main window::
	window := gtk_window_new (WINDOW_TOPLEVEL);
	window.set_title ("Canvas");
	-- window.set_border_width (10);

	-- Set the minimum size of the main window:
	window.set_size_request (500, 500);
	-- window.set_size_request (400, 200);
	-- window.set_size_request (gint (canvas_default_width), gint (canvas_default_height));
	-- window.set_default_size (gint (canvas_default_width), gint (canvas_default_height));
	window.on_destroy (cb_terminate'access);
	window.on_size_allocate (cb_size_allocate_main'access);

	
	
	-- Create a scrolled window:
	swin := gtk_scrolled_window_new (hadjustment => null, vadjustment => null);
	scrollbar_h_adj := swin.get_hadjustment;
	scrollbar_v_adj := swin.get_vadjustment;

	-- Connect the signal "value-changed" of the scrollbars with 
	-- procedures cb_vertical_moved and cb_horizontal_moved. So the user
	-- can watch how the signals are emitted:
	scrollbar_v_adj.on_value_changed (cb_vertical_moved'access);
	scrollbar_h_adj.on_value_changed (cb_horizontal_moved'access);

	scrollbar_v := swin.get_vscrollbar;
	scrollbar_v.on_button_press_event (cb_scrollbar_v_pressed'access);
	scrollbar_v.on_button_release_event (cb_scrollbar_v_released'access);

	
	-- swin.set_border_width (5);

	swin.set_policy ( -- for scrollbars
		hscrollbar_policy => gtk.enums.POLICY_AUTOMATIC, 
		vscrollbar_policy => gtk.enums.POLICY_AUTOMATIC);


	-- Set up the drawing area:
	gtk_new (canvas);

	canvas.on_realize (cb_realized'access );
	canvas.on_size_allocate (cb_size_allocate'access);

	
	-- Set the minimum size of the canvas (in pixels).
	-- It is like the wooden frame around a real-world canvas. 
	-- The size of the bounding
	-- rectangle MUST be known beforehand of calling the
	-- callback procedure cb_draw (see below):
	canvas.set_size_request (1000, 1000); -- unit is pixels
	-- canvas.set_size_request (gint (canvas_default_width), gint (canvas_default_height)); -- unit is pixels

	
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


	
	-- Add the canvas as a child to the scrolled window:
	--swin.add_with_viewport (canvas);
	swin.add (canvas); 
	-- swin.set_propagate_natural_height (true);
	
	-- Add the scrolled window as a child to the main window:
	window.add (swin);

	window.show_all;
	gtk.main.main;
end draw;

