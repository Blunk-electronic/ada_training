with glib;
with gdk.types;
with gdk.types.keysyms;
with gtk.accel_group;
with ada.text_io;				use ada.text_io;
with ada.calendar;				use ada.calendar;
with ada.calendar.formatting;	use ada.calendar.formatting;

with gtk.main;					use gtk.main;


package body callbacks is

	procedure refresh (
		canvas	: access gtk_widget_record'class)
	is
		drawing_area : constant gtk_drawing_area := gtk_drawing_area (canvas);
	begin
		drawing_area.queue_draw;
	end refresh;

	
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
		-- the button id, logical pixel x/y position (
		-- see the specs of gdk_event_button in package gdk.event for more).
		
		use glib;
		event_handled : boolean := true;
	begin
		-- Output the time, button id, x and y position:
		put_line ("cb_button_pressed " & image (clock) 
			& " button " & guint'image (event.button)
			& " logical pixel x/y " & gdouble'image (event.x) & "/" & gdouble'image (event.y));

		return event_handled;
	end cb_button_pressed;


	
	function cb_mouse_moved (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_motion)
		return boolean
	is
		-- The given event provides a lot of information like
		-- the logical pixel x/y position (see the specs of gdk_event_motion
		-- in package gdk.event for more).

		use glib;
		event_handled : boolean := true;
	begin
		-- Output the x/y position of the pointer
		-- in logical an model coordinates:
		put_line ("cb_mouse_moved "
			& "logical pixel x/y " 
			& gdouble'image (event.x) & "/" & gdouble'image (event.y)
			& " model x/y " 
			& gdouble'image (event.x/scale_factor) & "/" & gdouble'image (event.y/scale_factor));
		
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



	function cb_mouse_wheel_rolled (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_scroll)
		return boolean
	is
		-- The given event provides a lot of information like
		-- the direction of rotation, logical pixel x/y position
		-- (see the specs of gdk_event_scroll in package gdk.event for more).
		
		use glib;		
		use gdk.types;
		use gtk.accel_group;
		event_handled : boolean := true;

		accel_mask : gdk_modifier_type := get_default_mod_mask;
		direction : gdk_scroll_direction := event.direction;
	begin
		-- Output the time and the gdk_key_type (which is
		-- just a number (see gdk.types und gdk.types.keysyms)):
		put_line ("cb_mouse_wheel_rolled " & image (clock)
			& " logical pixel x/y " & gdouble'image (event.x) & "/" & gdouble'image (event.y)
			& " direction " & gdk_scroll_direction'image (direction));


		-- If CTRL is being pressed, zoom in or out:
		if (event.state and accel_mask) = control_mask then
			case direction is
				when SCROLL_UP => 
					scale_factor := scale_factor * 2.0;
					put_line ("zoom in.  scale " & gdouble'image (scale_factor));
					refresh (canvas);

				when SCROLL_DOWN => 
					scale_factor := scale_factor * 0.5;
					put_line ("zoom out. scale " & gdouble'image (scale_factor));
					refresh (canvas);
					
				when others => null;
			end case;
		end if;
		
		return event_handled;
	end cb_mouse_wheel_rolled;


	
	
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

		scale (context, scale_factor, scale_factor);
		rectangle (context, 1.0, 1.0, 400.0, 200.0);
		stroke (context);

		return event_handled;
	end cb_draw;

	
end callbacks;

