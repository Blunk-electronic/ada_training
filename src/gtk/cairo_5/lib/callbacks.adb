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



	scale : gdouble := 1.0;
	scale_old : gdouble := 1.0;
	
	offset_x : constant gdouble :=    10.0;
	offset_y : constant gdouble := -1000.0;

	zoom_center_x_m : gdouble := 0.0;
	zoom_center_y_m : gdouble := 0.0;

	zoom_center_x_c : gdouble := 0.0;
	zoom_center_y_c : gdouble := 0.0;

	translate_x : gdouble := 0.0;
	translate_y : gdouble := 0.0;

	
	procedure increase_scale is 
		m : constant gdouble := 2.0;
	begin
		scale_old := scale;
		scale := scale * m;
	end increase_scale;
	
	procedure decrease_scale is 
		m : constant gdouble := 2.0;
	begin
		scale_old := scale;
		scale := scale / m;
	end decrease_scale;

	



	-- Translates from model x-coordinate to canvas coordinate:	
	function x_to_canvas (
		x : in gdouble)
		return gdouble
	is
		result : gdouble;
	begin
		--result := x + (offset_x * scale_x);
		--result := (x + offset_x) * scale;
		result := (x * scale + offset_x);
		--result := (x * scale + offset_x) + translate_x;
		return result;
	end x_to_canvas;
		
	-- Translates from model y-coordinate to canvas coordinate:	
	function y_to_canvas (
		y : in gdouble)
		return gdouble
	is
		result : gdouble;
	begin
		-- result := - (y + (offset_y * scale_y));
		-- result := -(y + offset_y) * scale;
		result := -(y * scale + offset_y);
		-- result := -(y * scale + offset_y) + translate_y;
		return result;
	end y_to_canvas;



	-- Translates from canvas x-coordinate to model coordinate:
	function x_to_model (
		x : in gdouble)
		return gdouble
	is
		result : gdouble;
	begin
		--result := x - (offset_x * scale_x);
		-- result := x / scale - offset_x;
		result := (x - translate_x - offset_x) / scale;
		return result;
	end x_to_model;

	-- Translates from canvas y-coordinate to model coordinate:	
	function y_to_model (
		y : in gdouble)
		return gdouble
	is 
		result : gdouble;
	begin
		--result := -y - (offset_y * scale_y);
		-- result := -y / scale - offset_y;
		result := ( -(y - translate_y) - offset_y) / scale;
		return result;
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

		model_x : constant gdouble := x_to_model (event.x);
		model_y : constant gdouble := y_to_model (event.y);
	begin
		-- Output the x/y position of the pointer
		-- in logical and model coordinates:
		put_line (
			"logical pixel x/y " 
			& gdouble'image (event.x) & "/" & gdouble'image (event.y)

			-- The model-coordinates must be reverse-calculated
			-- from the logical pixel coordinates:
			& " model x/y "
			& gdouble'image (model_x) & "/" 
			& gdouble'image (model_y)

			-- TEST:
			-- The canvas-coordinates must match
			-- the original logical pixel coordinates:
			-- & " canvas x/y "
			-- & gdouble'image (x_to_canvas (model_x)) & "/" 
			-- & gdouble'image (y_to_canvas (model_y))
			);
		
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

		procedure set_zoom_center_model is begin
			zoom_center_x_m := x_to_model (event.x);
			zoom_center_y_m := y_to_model (event.y);
			put_line ("zoom center x/y" 
				& gdouble'image (zoom_center_x_m) & " / "
				& gdouble'image (zoom_center_y_m));
		end;

		procedure set_zoom_center_canvas is begin
			zoom_center_x_c := event.x;
			zoom_center_y_c := event.y;
		end;
			
	begin
		-- Output the time and the gdk_key_type (which is
		-- just a number (see gdk.types und gdk.types.keysyms)):
		put_line ("mouse_wheel_rolled "
			& " logical pixel x/y " & gdouble'image (event.x) & "/" & gdouble'image (event.y)
			& " direction " & gdk_scroll_direction'image (direction));


		-- If CTRL is being pressed, zoom in or out:
		if (event.state and accel_mask) = control_mask then
			set_zoom_center_canvas;
			
			case direction is
				when SCROLL_UP => 
					increase_scale;
					set_zoom_center_model;
					put_line ("zoom in.  scale " & gdouble'image (scale));
					refresh (canvas);

				when SCROLL_DOWN => 
					decrease_scale;
					set_zoom_center_model;
					put_line ("zoom out. scale " & gdouble'image (scale));
					refresh (canvas);
					
				when others => null;
			end case;
		end if;
		
		return event_handled;
	end cb_mouse_wheel_rolled;

	
-- https://stackoverflow.com/questions/2916081/zoom-in-on-a-point-using-scale-and-translate
	
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
		-- translate (context, offset_x, offset_y);
		-- translate (context, x_to_canvas (zoom_center_x_m), y_to_canvas (zoom_center_y_m));
		--translate (context, zoom_center_x_c, zoom_center_y_c);
		translate (context, translate_x, translate_y);
		
		-- All scaling operations have the new origin
		-- as its center:
		-- scale (context, scale_x, scale_y);

		
		-- The rectangle is specified in real-world model coordinates
		-- where y increases upwards:
		-- rectangle (context, 0.0 - zoom_center_x_m, 0.0 - zoom_center_y_m, 400.0, 200.0);

		rectangle (context, x_to_canvas (0.0), y_to_canvas (0.0),
			400.0 * scale, -200.0 * scale); -- ok ohne zoom

		-- rectangle (context, 
		-- 	x_to_canvas (0.0 - zoom_center_x_m), 
		-- 	y_to_canvas (0.0 - zoom_center_y_m),
		-- 	 400.0 * scale,  -- width
		-- 	-200.0 * scale); -- height

		
		stroke (context);

		-- destroy (context); -- exception assertion failed ...
		return event_handled;
	end cb_draw;

	
end callbacks;

