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



	scale_x : gdouble := 1.0;
	scale_y : gdouble := -1.0; -- because y increases upwards in this world
	offset_x : constant gdouble := 0.0;
	offset_y : constant gdouble := 1000.0;

	
	procedure increase_scale is 
		m : constant gdouble := 2.0;
	begin
		scale_x := scale_x * m;
		scale_y := scale_y * m;
	end increase_scale;

	
	procedure decrease_scale is 
		m : constant gdouble := 2.0;
	begin
		scale_x := scale_x / m;
		scale_y := scale_y / m;
	end decrease_scale;
	

	-- Translates from canvas x-coordinate to model coordinate:
	function x_to_model (
		x : in gdouble)
		return gdouble
	is begin
		return (x - offset_x) / scale_x;
	end x_to_model;


	-- Translates from canvas y-coordinate to model coordinate:	
	function y_to_model (
		y : in gdouble)
		return gdouble
	is begin
		return (y - offset_y) / scale_y;
	end y_to_model;

	
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
		-- in logical and model coordinates:
		put_line ("cb_mouse_moved "
			& "logical pixel x/y " 
			& gdouble'image (event.x) & "/" & gdouble'image (event.y)

			-- The model-coordinates must be reverse-calculated
			-- from the logical pixel coordinates:
			& " model x/y "
			& gdouble'image (x_to_model (event.x)) & "/" 
			& gdouble'image (y_to_model (event.y)));
											  
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
					increase_scale;
					put_line ("zoom in.  scale " & gdouble'image (scale_x));
					refresh (canvas);

				when SCROLL_DOWN => 
					decrease_scale;
					put_line ("zoom out. scale " & gdouble'image (scale_x));
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

		-- Offset the origin of the drawing:
		translate (context, offset_x, offset_y);
		
		-- All scaling operations have the new origin
		-- as its center:
		scale (context, scale_x, scale_y);

		-- The rectangle is specified in real-world model coordinates
		-- where y increases upwards:
		rectangle (context, 0.0, 0.0, 400.0, 200.0);
		stroke (context);

		-- destroy (context); -- exception assertion failed ...
		return event_handled;
	end cb_draw;

	
end callbacks;

