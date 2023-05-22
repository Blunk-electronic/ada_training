with glib;
with gdk.types;
with gdk.types.keysyms;
with ada.text_io;				use ada.text_io;
with ada.calendar;				use ada.calendar;
with ada.calendar.formatting;	use ada.calendar.formatting;

with gtk.main;					use gtk.main;


package body callbacks is

	procedure cb_terminate (
		main_window : access gtk_widget_record'class) 
	is begin
		put_line ("exiting ...");
		gtk.main.main_quit;
	end cb_terminate;


	procedure cb_horizontal_moved (
		scrollbar : access gtk_adjustment_record'class)
	is begin
		put_line ("horizontal moved " & image (clock));
	end cb_horizontal_moved;

	
	procedure cb_vertical_moved (
		scrollbar : access gtk_adjustment_record'class)
	is begin
		put_line ("vertical moved " & image (clock));
	end cb_vertical_moved;

	

	function cb_button_pressed (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean
	is
		-- The given event provides a lot of information like
		-- the button id, x/y position (see the specs of gdk_event_button
		-- in package gdk.event for more).
		use glib;
		event_handled : boolean := true;
	begin
		-- Output the time, button id, x and y position:
		put_line ("cb_button_pressed " & image (clock) 
			& " button " & guint'image (event.button)
			& " x/y " & gdouble'image (event.x) & "/" & gdouble'image (event.y));

		return event_handled;
	end cb_button_pressed;


	
	function cb_mouse_moved (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_motion)
		return boolean
	is
		-- The given event provides a lot of information like
		-- the x/y position (see the specs of gdk_event_motion
		-- in package gdk.event for more).

		use glib;
		event_handled : boolean := true;
	begin
		-- Output the time and x/y position of the pointer:
		put_line ("cb_mouse_moved " & image (clock)
			& " x/y " & gdouble'image (event.x) & "/" & gdouble'image (event.y));
		
		return event_handled;
	end cb_mouse_moved;



	
	function cb_key_pressed (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_key)
		return boolean
	is
		-- The given event provides a lot of information like
		-- the actual key (see the specs of gdk_event_key
		-- in package gdk.event for more).
		
		use gdk.types;		
		event_handled : boolean := true;
	begin
		-- Output the time and the gdk_key_type (which is
		-- just a number (see gdk.types und gdk.types.keysyms)):
		put_line ("cb_key_pressed " & image (clock)
			& " key " & gdk_key_type'image (event.keyval));
		
		return event_handled;
	end cb_key_pressed;


	
	
	function cb_draw (
		canvas	: access gtk_widget_record'class;
		context	: in cairo_context)
		return boolean
	is
		event_handled : boolean := true;
	begin
		put_line ("cb_draw " & image (clock));

		set_line_width (context, 1.0);
		set_source_rgb (context, 1.0, 0.0, 0.0);

		rectangle (context, 1.0, 1.0, 500.0, 100.0);
		stroke (context);
		
		return event_handled;
	end cb_draw;

	
end callbacks;

