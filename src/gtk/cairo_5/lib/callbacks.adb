with glib;
with gdk.types;
with gdk.types.keysyms;
with gtk.accel_group;
with ada.text_io;				use ada.text_io;
with ada.calendar;				use ada.calendar;
with ada.calendar.formatting;	use ada.calendar.formatting;

with gtk.main;					use gtk.main;

with geometry;					use geometry;


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
		use glib;
		event_handled : boolean := true;
		point : constant type_point_canvas := (event.x, event.y);
	begin
		-- Output the button id, x and y position:
		put_line ("cb_button_pressed "
			& " button " & guint'image (event.button)
			& to_string (point));

		return event_handled;
	end cb_button_pressed;



	
	
	function cb_mouse_moved (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_motion)
		return boolean
	is
		use glib;
		event_handled : boolean := true;

		cp : constant type_point_canvas := (event.x, event.y);
		mp : constant type_point_model := to_model (cp, scale_factor, translate_offset);
	begin
		-- Output the x/y position of the pointer
		-- in logical and model coordinates:
		put_line (
			to_string (cp)
			& " " & to_string (mp)

			-- TEST:
			-- The canvas-coordinates must match
			-- the original logical pixel coordinates:
			-- & to_string (to_canvas (mp, scale_factor, translate_offset))
			);
		
		return event_handled;
	end cb_mouse_moved;



	
	function cb_key_pressed (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_key)
		return boolean
	is
		use gdk.types;		
		event_handled : boolean := true;
	begin
		-- Output the the gdk_key_type (which is
		-- just a number (see gdk.types und gdk.types.keysyms)):
		put_line ("cb_key_pressed "
			& " key " & gdk_key_type'image (event.keyval));
		
		return event_handled;
	end cb_key_pressed;



	function cb_mouse_wheel_rolled (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_scroll)
		return boolean
	is
		use glib;		
		use gdk.types;
		use gtk.accel_group;
		event_handled : boolean := true;

		accel_mask : constant gdk_modifier_type := get_default_mod_mask;
		direction : constant gdk_scroll_direction := event.direction;

		-- The given point on the canvas where the operator is zooming in or out:
		cp : constant type_point_canvas := (event.x, event.y);

		-- The corresponding real-world point (in the model)
		-- according to the CURRENT (old) scale_factor and translate_offset:
		mp : constant type_point_model := to_model (cp, scale_factor, translate_offset);


		-- After changing the scale_factor, the translate_offset must
		-- be calculated anew. When the actual drawing takes place (see function cb_draw)
		-- then the drawing will be dragged back by the translate_offset
		-- so that the operator gets the impression of a zoom-into or zoom-out effect.
		-- Without applying a translate_offset the drawing would be appearing as 
		-- expanding to the upper-right (on zoom-in) or shrinking toward the lower-left:
		procedure compute_translate_offset is 
			cp_after_scale : type_point_canvas;
		begin
			-- Compute the prospected canvas-point according to the new scale_factor:
			cp_after_scale := to_canvas (mp, scale_factor);
			put_line ("cp after scale " & to_string (cp_after_scale));

			-- This is the offset from the given canvas-point to the prospected
			-- canvas-point. The offset must be multiplied by -1 because the
			-- drawing must be dragged-back to the given pointer position:
			translate_offset.x := -(cp_after_scale.x - cp.x);
			translate_offset.y := -(cp_after_scale.y - cp.y);

			put_line ("translate offset " & to_string (translate_offset));
		end compute_translate_offset;

		
	begin
		-- Output the time and the gdk_key_type (which is
		-- just a number (see gdk.types und gdk.types.keysyms)):
		put_line ("mouse_wheel_rolled "
			& to_string (cp)
			& " direction " & gdk_scroll_direction'image (direction));


		-- If CTRL is being pressed, zoom in or out:
		if (event.state and accel_mask) = control_mask then
			
			case direction is
				when SCROLL_UP => 
					increase_scale; -- increases the scale_factor
					put_line ("zoom in  " & to_string (scale_factor));
					compute_translate_offset;
					refresh (canvas);

				when SCROLL_DOWN => 
					decrease_scale; -- decrease the scale_factor
					put_line ("zoom out " & to_string (scale_factor));
					compute_translate_offset;
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

		-- NOTE: The rectangle is specified in real-world model coordinates
		-- where y increases upwards.
		R : type_rectangle;

		
		cp : type_point_canvas;
	begin
		put_line ("cb_draw " & image (clock));

		set_line_width (context, 1.0);
		set_source_rgb (context, 1.0, 0.0, 0.0);

		-- Offset the origin of the drawing:
		translate (context, translate_offset.x, translate_offset.y);
		
		
		cp := to_canvas (R.lower_left_corner, scale_factor);
		
		rectangle (context, 
			cp.x, cp.y,	-- lower left corner
			gdouble (R.width)  * gdouble  (scale_factor),  -- width
			gdouble (R.height) * gdouble (-scale_factor)); -- height


		
		stroke (context);

		-- destroy (context); -- exception assertion failed ...
		return event_handled;
	end cb_draw;

	
end callbacks;

