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
		v_lower : gdouble := scrollbar_v_adj.get_lower;
		v_value : gdouble := scrollbar_v_adj.get_value;
		v_upper : gdouble := scrollbar_v_adj.get_upper;
		v_page  : gdouble := scrollbar_v_adj.get_page_size;
	begin
		put_line ("v adjustments");
		put_line ("lower" & gdouble'image (v_lower));
		put_line ("upper" & gdouble'image (v_upper));
		put_line ("page " & gdouble'image (v_page));
		put_line ("value" & gdouble'image (v_value));
	end;
				  

	procedure show_canvas_size is 
		width, height : gint;
	begin
		canvas.get_size_request (width, height);
		put_line ("canvas size" & gint'image (width) & " /" & gint'image (height));
	end show_canvas_size;

	
	procedure adjust_canvas_size (
		extra_height : in gdouble)
	is 
		h_init, h_scaled, h_final : gint;
	begin
		if scale_factor >= 1.0 then
			h_init := canvas_height;
			put_line ("h_init " & gint'image (h_init));

			h_scaled := gint (canvas_default_height * gdouble (scale_factor));
			put_line ("h_scaled " & gint'image (h_scaled));
			
			if h_init > h_scaled then
				h_final := h_init + gint (extra_height);
			else
				h_final := h_scaled + gint (extra_height);
			end if;
			
			canvas.set_size_request (
				gint (canvas_default_width  * gdouble (scale_factor)),
				h_final);

		end if;
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
		-- show_adjustments;
	end cb_vertical_moved;


	function cb_scrollbar_v_pressed (
		bar		: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean
	is
		event_handled : boolean := false;
	begin
		new_line;
		put_line ("cb_scrollbar_v_pressed");
		v_user_old := scrollbar_v_adj.get_value;

		return event_handled;
	end cb_scrollbar_v_pressed;


	function cb_scrollbar_v_released (
		bar		: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean
	is
		event_handled : boolean := false;
		v_delta : gdouble := scrollbar_v_adj.get_value - v_user_old;
	begin
		new_line;
		put_line ("cb_scrollbar_v_released");
		v_user := v_user + v_delta;
		put_line ("v_user set to " & gdouble'image (v_user));
		-- show_adjustments;
		
		return event_handled;
	end cb_scrollbar_v_released;



	procedure cb_size_allocate (
		canvas		: access gtk_widget_record'class;
		allocation	: gtk_allocation)
	is
	begin
		-- new_line;
		-- put_line ("cb_size_allocate");
		put_line ("cb_size_allocate. pos: " & gint'image (allocation.x) 
			& " /" & gint'image (allocation.y)
			& "    width/height:" & gint'image (allocation.width)
			& " /" & gint'image (allocation.height));

		canvas_height := allocation.height;
	end cb_size_allocate;

	

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
		null;
		-- Output the x/y position of the pointer
		-- in logical and model coordinates:
		-- put_line (
		-- 	to_string (cp)
		-- 	& " " & to_string (mp)

			-- TEST:
			-- The canvas-coordinates must match
			-- the original logical pixel coordinates:
			-- & to_string (to_canvas (mp, scale_factor, translate_offset))
			-- );
		
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
			-- put_line ("cp after scale   " & to_string (cp_after_scale));

			-- This is the offset from the given canvas-point to the prospected
			-- canvas-point. The offset must be multiplied by -1 because the
			-- drawing must be dragged-back to the given pointer position:
			translate_offset.x := -(cp_after_scale.x - cp.x);
			translate_offset.y := -(cp_after_scale.y - cp.y);
			
			--put_line ("translate offset " & to_string (translate_offset));
		end compute_translate_offset;


		top_excess : gdouble;
		
		procedure set_offset_and_v_adjustment is
			canvas_height : gint;
			canvas_width : gint;
		begin
			v_corr := 0.0;
			if top_excess > 0.0 then
				-- put_line ("top excess");
				put_line ("top excess " & gdouble'image (top_excess));
				base_offset.y := base_offset_default.y - top_excess;
				-- put_line ("base offset y    " & gdouble'image (base_offset.y));

				v_corr := top_excess;
				v_corr := v_user + v_corr;
				put_line ("v_corr " & gdouble'image (v_corr));
				-- put_line ("v_user " & gdouble'image (v_user));

				canvas.get_size_request (canvas_width, canvas_height);
				scrollbar_v_adj.set_upper (gdouble (canvas_height)); -- does not affect page_size
				-- show_adjustments;
			
			else
				put_line ("NO top excess");
				base_offset := base_offset_default;
				v_corr := v_user; -- ok
			end if;

			scrollbar_v_adj.set_value (v_corr);
			-- show_adjustments;
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
					top_excess := - (to_canvas (top_right, scale_factor, base_offset_default).y);
					adjust_canvas_size (top_excess);
					
					compute_translate_offset;
					set_offset_and_v_adjustment;
					refresh (canvas);

				when SCROLL_DOWN => 
					decrease_scale; -- decrease the scale_factor
					put_line ("zoom out " & to_string (scale_factor));
					top_excess := - (to_canvas (top_right, scale_factor, base_offset_default).y);
					adjust_canvas_size (top_excess);
					
					compute_translate_offset;
					set_offset_and_v_adjustment;
					refresh (canvas);
					
				when others => null;
			end case;

		end if;

		-- show_adjustments;
		return event_handled;
	end cb_mouse_wheel_rolled;


	
	function cb_draw (
		canvas	: access gtk_widget_record'class;
		context	: in cairo_context)
		return boolean
	is
		event_handled : boolean := true;
		cp : type_point_canvas;
	begin
		-- new_line;
		put_line ("cb_draw " & image (clock));
		-- show_canvas_size;
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
		
		return event_handled;
	end cb_draw;

	
end callbacks;

