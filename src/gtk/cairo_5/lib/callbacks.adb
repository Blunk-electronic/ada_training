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


	procedure show_adjustments is 
		v_lower : gdouble := vertical.get_lower;
		v_value : gdouble := vertical.get_value;
		v_upper : gdouble := vertical.get_upper;
		v_page  : gdouble := vertical.get_page_size;
	begin
		put_line ("v adjustments");
		put_line ("lower" & gdouble'image (v_lower));
		put_line ("upper" & gdouble'image (v_upper));
		put_line ("page " & gdouble'image (v_page));
		put_line ("value" & gdouble'image (v_value));
	end;
				  
	
	procedure adjust_canvas_size is 
		width, height : gint;
	begin
		canvas.get_size_request (width, height);
		put_line ("canvas size old" & gint'image (width) & "/" & gint'image (height));
		
		-- canvas.set_size_request (
		-- 	gint (gdouble (width)  * gdouble (scale_factor)),
		-- 	gint (gdouble (height) * gdouble (scale_factor)));

		canvas.set_size_request (
			gint (800.0 * gdouble (scale_factor)),
			gint (400.0 * gdouble (scale_factor)));

		
		canvas.get_size_request (width, height);
		put_line ("canvas size new" & gint'image (width) & "/" & gint'image (height));
	end adjust_canvas_size;


	
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
		show_adjustments;
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
		mp : constant type_point_model := to_model (cp, scale_factor, translate_offset, base_offset);
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
		mp : constant type_point_model := to_model (cp, scale_factor, translate_offset, base_offset);

		
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
			cp_after_scale := to_canvas (mp, scale_factor, base_offset);
			put_line ("cp after scale   " & to_string (cp_after_scale));

			-- This is the offset from the given canvas-point to the prospected
			-- canvas-point. The offset must be multiplied by -1 because the
			-- drawing must be dragged-back to the given pointer position:
			translate_offset.x := -(cp_after_scale.x - cp.x);
			translate_offset.y := -(cp_after_scale.y - cp.y);
			
			--put_line ("translate offset " & to_string (translate_offset));

			-- show_adjustments;
			adjust_canvas_size;
		end compute_translate_offset;


		procedure set_offset_and_v_adjustment is
			tr : type_point_canvas;
			v_corr : gdouble := 0.0;
		begin
			tr := to_canvas (top_right, scale_factor, base_offset_default);
			if tr.y < 0.0 then
				put_line ("top right excess " & to_string (tr));
				base_offset.y := base_offset_default.y + tr.y;
				put_line ("base offset y    " & gdouble'image (base_offset.y));

				--v_corr := -tr.y;
				show_adjustments;
				v_corr := vertical.get_value + (-tr.y);
				show_adjustments;
				put_line ("v_corr " & gdouble'image (v_corr));
				
			else
				base_offset := base_offset_default;
				v_corr := 0.0;
			end if;
			
			vertical.set_value (v_corr);
		end set_offset_and_v_adjustment;

		
	begin
		-- Output the time and the gdk_key_type (which is
		-- just a number (see gdk.types und gdk.types.keysyms)):
		new_line;
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
					set_offset_and_v_adjustment;
					refresh (canvas);

				when SCROLL_DOWN => 
					decrease_scale; -- decrease the scale_factor
					put_line ("zoom out " & to_string (scale_factor));
					compute_translate_offset;
					set_offset_and_v_adjustment;
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
		-- R : type_rectangle;

		
		cp : type_point_canvas;
	begin
		put_line ("cb_draw " & image (clock));

		-- show_adjustments;

		set_line_width (context, 1.0);
		set_source_rgb (context, 1.0, 0.0, 0.0);

		-- Drag the drawing by the current translate_offset.
		-- The translate_offset has been calculated earlier by 
		-- procedure cb_mouse_wheel_rolled:
		translate (context, translate_offset.x, translate_offset.y);
		
		-- Compute the canvas-point where the lower-left corner
		-- of the rectangle is:
		cp := to_canvas (object.lower_left_corner, scale_factor, base_offset);

		-- Draw the rectangle:
		rectangle (context, 
			cp.x, cp.y,	-- lower left corner
			gdouble (object.width)  * gdouble  (scale_factor),  -- width
			gdouble (object.height) * gdouble (-scale_factor)); -- height

		
		stroke (context);

		-- destroy (context); -- exception assertion failed ...

		-- if v_corr_required then
		-- 	vertical.set_value (v_corr);
		-- end if;
		
		return event_handled;
	end cb_draw;

	
end callbacks;

