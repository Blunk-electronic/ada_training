with glib;
with gdk.types;
with gdk.types.keysyms;
with gtk.accel_group;
with gtk.enums;					use gtk.enums;
with ada.text_io;				use ada.text_io;
with ada.calendar;				use ada.calendar;
with ada.calendar.formatting;	use ada.calendar.formatting;

with gtk.main;					use gtk.main;



package body callbacks is

-- MAIN WINDOW:
	
	procedure cb_terminate (
		main_window : access gtk_widget_record'class) 
	is begin
		put_line ("exiting ...");
		gtk.main.main_quit;
	end cb_terminate;


	procedure cb_size_allocate_main (
		window		: access gtk_widget_record'class;
		allocation	: gtk_allocation)
	is
	begin
		null;
		-- new_line;
		-- put_line ("cb_size_allocate_main. pos: " & gint'image (allocation.x) 
		-- 	& " /" & gint'image (allocation.y)
		-- 	& "    width/height:" & gint'image (allocation.width)
		-- 	& " /" & gint'image (allocation.height));

	end cb_size_allocate_main;

	
	
	procedure set_up_main_window is
	begin
		main_window := gtk_window_new (WINDOW_TOPLEVEL);
		main_window.set_title ("Canvas");
		-- main_window.set_border_width (10);

		-- Set the minimum size of the main window basing on the 
		-- bounding-box:
		main_window.set_size_request (
			gint (bounding_box.width),
			gint (bounding_box.height));

		-- CS show main window size
		
		-- connect signals:
		main_window.on_destroy (cb_terminate'access);
		main_window.on_size_allocate (cb_size_allocate_main'access);
		main_window.on_button_press_event (cb_button_pressed_win'access);

	end set_up_main_window;


	

-- SCROLLED WINDOW:

	function cb_button_pressed_win (
		swin	: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean
	is
		use glib;
		event_handled : boolean := true;
		point : constant type_point_canvas := (event.x, event.y);
	begin
		null;
		
		-- -- Output the button id, x and y position:
		-- put_line ("cb_button_pressed_win "
		-- 	& " button " & guint'image (event.button)
		-- 	& to_string (point));

		return event_handled;
	end cb_button_pressed_win;



	
-- SCROLLBARS:


	procedure compute_V_LM_UM is begin
		V_LM := scrollbar_v_adj.get_value - scrollbar_v_adj.get_lower;
		V_UM := scrollbar_v_adj.get_upper - (scrollbar_v_adj.get_value + scrollbar_v_adj.get_page_size);

		-- put_line ("V_LM" & gdouble'image (V_LM));
		-- put_line ("V_UM" & gdouble'image (V_UM));
	end compute_V_LM_UM;

	
	procedure compute_H_LM_UM is begin
		-- left:
		H_LM := scrollbar_h_adj.get_value - scrollbar_h_adj.get_lower;

		-- right:
		H_UM := scrollbar_h_adj.get_upper - (scrollbar_h_adj.get_value + scrollbar_h_adj.get_page_size);

		-- put_line ("H_LM" & gdouble'image (H_LM));
		-- put_line ("H_UM" & gdouble'image (H_UM));
	end compute_H_LM_UM;

	
	procedure cb_horizontal_moved (
		scrollbar : access gtk_adjustment_record'class)
	is 
	begin
		-- put_line ("horizontal moved " & image (clock));
		null;
		-- show_adjustments_h;
		-- put_line ("visible " & to_string (get_visible_area (canvas)));
	end cb_horizontal_moved;

	
	procedure cb_vertical_moved (
		scrollbar : access gtk_adjustment_record'class)
	is begin		
		-- put_line ("vertical moved " & image (clock));
		null;
		-- show_adjustments_v;
		-- put_line ("visible " & to_string (get_visible_area (canvas)));
	end cb_vertical_moved;


	function cb_scrollbar_v_pressed (
		bar		: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean
	is
		event_handled : boolean := false;
	begin
		-- put_line ("cb_scrollbar_v_pressed");
		return event_handled;
	end cb_scrollbar_v_pressed;

	
	function cb_scrollbar_v_released (
		bar		: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean
	is
		event_handled : boolean := false;
	begin
		-- put_line ("cb_scrollbar_v_released");
		compute_V_LM_UM;
		return event_handled;
	end cb_scrollbar_v_released;



	function cb_scrollbar_h_pressed (
		bar		: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean
	is
		event_handled : boolean := false;
	begin
		-- put_line ("cb_scrollbar_h_pressed");
		return event_handled;
	end cb_scrollbar_h_pressed;

	
	function cb_scrollbar_h_released (
		bar		: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean
	is
		event_handled : boolean := false;
	begin
		-- put_line ("cb_scrollbar_h_released");
		compute_H_LM_UM;
		return event_handled;
	end cb_scrollbar_h_released;

	

	procedure set_up_scrollbars is
	begin
		-- Create a scrolled window:
		swin := gtk_scrolled_window_new (hadjustment => null, vadjustment => null);
		-- swin.set_border_width (10);

		
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

		scrollbar_h := swin.get_hscrollbar;
		scrollbar_h.on_button_press_event (cb_scrollbar_h_pressed'access);
		scrollbar_h.on_button_release_event (cb_scrollbar_h_released'access);


		-- behaviour:
		swin.set_policy ( -- for scrollbars
			hscrollbar_policy => gtk.enums.POLICY_AUTOMATIC,
			-- hscrollbar_policy => gtk.enums.POLICY_NEVER, 
			vscrollbar_policy => gtk.enums.POLICY_AUTOMATIC);
			-- vscrollbar_policy => gtk.enums.POLICY_NEVER);

	end set_up_scrollbars;



	
	procedure show_adjustments_v is 
		v_lower : gdouble := scrollbar_v_adj.get_lower;
		v_value : gdouble := scrollbar_v_adj.get_value;
		v_upper : gdouble := scrollbar_v_adj.get_upper;
		v_page  : gdouble := scrollbar_v_adj.get_page_size;
	begin
		put_line ("vertical scrollbar adjustments:");
		put_line (" lower" & gdouble'image (v_lower));
		put_line (" upper" & gdouble'image (v_upper));
		put_line (" page " & gdouble'image (v_page));
		put_line (" value" & gdouble'image (v_value));
	end show_adjustments_v;
				  

	procedure show_adjustments_h is 
		h_lower : gdouble := scrollbar_h_adj.get_lower;
		h_value : gdouble := scrollbar_h_adj.get_value;
		h_upper : gdouble := scrollbar_h_adj.get_upper;
		h_page  : gdouble := scrollbar_h_adj.get_page_size;
	begin
		put_line ("horizontal scrollbar adjustments:");
		put_line (" lower" & gdouble'image (h_lower));
		put_line (" upper" & gdouble'image (h_upper));
		put_line (" page " & gdouble'image (h_page));
		put_line (" value" & gdouble'image (h_value));
	end show_adjustments_h;

	
	
	procedure prepare_initial_scrollbar_settings is
	begin
		put_line ("prepare initial scrollbar settings");
		
		scrollbar_v_init.upper := - base_offset.y;			
		scrollbar_v_init.lower := scrollbar_v_init.upper - gdouble (bounding_box.height);
		scrollbar_v_init.page_size := gdouble (bounding_box.height);
		scrollbar_v_init.value := scrollbar_v_init.lower;

		put_line (" vertical:");
		put_line ("  lower" & gdouble'image (scrollbar_v_init.lower));
		put_line ("  upper" & gdouble'image (scrollbar_v_init.upper));
		put_line ("  page " & gdouble'image (scrollbar_v_init.page_size));
		put_line ("  value" & gdouble'image (scrollbar_v_init.value));

		
		scrollbar_h_init.lower := base_offset.x;
		scrollbar_h_init.upper := scrollbar_h_init.lower + gdouble (bounding_box.width);
		scrollbar_h_init.page_size := gdouble (bounding_box.width);
		scrollbar_h_init.value := scrollbar_h_init.lower;

		put_line (" horizontal:");
		put_line ("  lower" & gdouble'image (scrollbar_h_init.lower));
		put_line ("  upper" & gdouble'image (scrollbar_h_init.upper));
		put_line ("  page " & gdouble'image (scrollbar_h_init.page_size));
		put_line ("  value" & gdouble'image (scrollbar_h_init.value));
	end prepare_initial_scrollbar_settings;


	
	
	procedure apply_initial_scrollbar_settings is
	begin
		put_line ("apply initial scrollbar settings");

		-- put_line ("vertical:");
		scrollbar_v_adj.set_upper (scrollbar_v_init.upper);			
		scrollbar_v_adj.set_lower (scrollbar_v_init.lower);
		scrollbar_v_adj.set_page_size (scrollbar_v_init.page_size);
		scrollbar_v_adj.set_value (scrollbar_v_init.value);

		-- put_line ("horizontal:");
		scrollbar_h_adj.set_upper (scrollbar_h_init.upper);			
		scrollbar_h_adj.set_lower (scrollbar_h_init.lower);
		scrollbar_h_adj.set_page_size (scrollbar_h_init.page_size);
		scrollbar_h_adj.set_value (scrollbar_h_init.value);
	end apply_initial_scrollbar_settings;
	

	

	
-- CANVAS:
	
	procedure refresh (
		canvas	: access gtk_widget_record'class)
	is
		drawing_area : constant gtk_drawing_area := gtk_drawing_area (canvas);
	begin
		drawing_area.queue_draw;
	end refresh;


	procedure cb_size_allocate (
		canvas		: access gtk_widget_record'class;
		allocation	: gtk_allocation)
	is begin
		null;
		-- new_line;
		-- put_line ("cb_size_allocate");
		put_line ("cb_size_allocate. pos: " & gint'image (allocation.x) 
			& " /" & gint'image (allocation.y)
			& "    width/height:" & gint'image (allocation.width)
			& " /" & gint'image (allocation.height));

	end cb_size_allocate;


	
	

	procedure show_canvas_size is 
		width, height : gint;
	begin
		canvas.get_size_request (width, height);
		put_line ("canvas size" & gint'image (width) & " /" & gint'image (height));
	end show_canvas_size;

	
	
	procedure set_up_canvas is
		size_x, size_y : gint;
	begin
		-- Set up the drawing area:
		gtk_new (canvas);

		canvas.on_realize (cb_realized'access );
		canvas.on_size_allocate (cb_size_allocate'access);

		
		-- Set the size of the canvas (in pixels).
		-- It is like the wooden frame around a real-world canvas. 
		size_x := gint (scrollbar_h_init.upper + scrollbar_h_init.lower);
		size_y := gint (scrollbar_v_init.upper + scrollbar_v_init.lower);

		canvas.set_size_request (size_x, size_y); -- unit is pixels

		show_canvas_size;

		
		
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

	end set_up_canvas;



	function model_point_visible (
		point 		: in type_point_model)
		return type_model_point_visible
	is
		result : type_model_point_visible;
		C : type_point_canvas;
	begin
		-- put_line ("M " & to_string (point));
		
		C := to_canvas (
			point	=> point,
			scale	=> scale_factor,
			real	=> true);

		-- put_line ("C " & to_string (C));

		-- X-axis:
		-- The visible area ranges from the current position
		-- of the horizontal scrollbar (value) to the end of the
		-- scrollbar (value + page_size). If C.x lies in that range,
		-- then the corresponding flag in the return will be set.
		if C.x >= scrollbar_h_adj.get_value and
			C.x <= scrollbar_h_adj.get_value + scrollbar_h_adj.get_page_size then
			result.x := true;
			-- put_line ("X visible");	
		end if;

		
		-- Y-axis:
		-- The visible area ranges from the current position
		-- of the vertical scrollbar (value) to the end of the
		-- scrollbar (value + page_size). If C.y lies in that range,
		-- then the corresponding flag in the return will be set.
		if C.y >= scrollbar_v_adj.get_value and
			C.y <= scrollbar_v_adj.get_value + scrollbar_v_adj.get_page_size then
			result.y := true;
			-- put_line ("Y visible");	
		end if;

		return result;
	end model_point_visible;

	

	function get_visible_area (
		canvas	: access gtk_widget_record'class)
		return type_area
	is
		result : type_area;

		h_start  : constant gdouble := scrollbar_h_adj.get_value;
		h_length : constant gdouble := scrollbar_h_adj.get_page_size;
		h_end    : constant gdouble := h_start + h_length;
		
		v_start	 : constant gdouble := scrollbar_v_adj.get_value;
		v_length : constant gdouble := scrollbar_v_adj.get_page_size;
		v_end	 : constant gdouble := v_start + v_length;

		BL, BR, TL, TR : type_point_model;
	begin
		BL := to_model ((h_start, v_end), scale_factor, true);
		result.position := BL;

		BR := to_model ((h_end, v_end), scale_factor, true);
		TL := to_model ((h_start, v_start), scale_factor, true);
		TR := to_model ((h_end, v_start), scale_factor, true);

		-- put_line ("BL " & to_string (BL));
		-- put_line ("BR " & to_string (BR));
		-- put_line ("TR " & to_string (TR));
		-- put_line ("TL " & to_string (TL));

		-- CS: more effective ?
		-- result.width    := type_distance_model (h_length) * type_distance_model (scale_factor);
		-- result.height   := type_distance_model (v_length) * type_distance_model (scale_factor);

		result.width := TR.x - TL.x;
		result.height := TL.y - BL.y;

		-- put_line ("visible area " & to_string (result));
		return result;
	end get_visible_area;

	
	
	
	function cb_button_pressed (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean
	is
		use glib;
		event_handled : boolean := false;
		point : constant type_point_canvas := (event.x, event.y);

		mp : constant type_point_model := to_model (
			point 	=> point,
			scale	=> scale_factor,
			real	=> true);
	begin
		-- Output the button id, x and y position:
		put_line ("cb_button_pressed "
			& " button" & guint'image (event.button) & " "
			& to_string (point));

		put_line (to_string (mp));
		
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
		mp : constant type_point_model := to_model (cp, scale_factor);
	begin
		null;
		-- Output the x/y position of the pointer
		-- in logical and model coordinates:
		-- put_line (
			-- to_string (cp)
			-- & " " & to_string (mp)

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


	procedure cb_realized (
		canvas	: access gtk_widget_record'class)
	is
	begin
		put_line ("canvas realized");
	end cb_realized;



	
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
		Z : constant type_point_canvas := (event.x, event.y);

		-- The corresponding model-point
		-- according to the CURRENT (old) scale_factor:
		mp : constant type_point_model := to_model (Z, scale_factor);

		
		-- After changing the scale_factor, the translate_offset must
		-- be calculated anew. When the actual drawing takes place (see function cb_draw)
		-- then the drawing will be dragged back by the translate_offset
		-- so that the operator gets the impression of a zoom-into or zoom-out effect.
		-- Without applying a translate_offset the drawing would be appearing as 
		-- expanding to the upper-right (on zoom-in) or shrinking toward the lower-left:
		procedure compute_translate_offset is 
			Z_after_scale : type_point_canvas;
		begin			
			-- Compute the prospected canvas-point according to the new scale_factor:
			Z_after_scale := to_canvas (mp, scale_factor);
			-- put_line ("Z after scale   " & to_string (Z_after_scale));

			-- This is the offset from the given canvas-point to the prospected
			-- canvas-point. The offset must be multiplied by -1 because the
			-- drawing must be dragged-back to the given pointer position:
			translate_offset.x := -(Z_after_scale.x - Z.x);
			translate_offset.y := -(Z_after_scale.y - Z.y);
			
			-- put_line ("translate offset " & to_string (translate_offset));
		end compute_translate_offset;




		

		-- Get the corners of the bounding-box as it is BEFORE scaling:
		BC : constant type_area_corners := get_corners (bounding_box);


		
		procedure update_scrollbar_limits is
			TL, BL, BR : type_point_canvas;
		begin
			TL := to_canvas (BC.TL, scale_factor, true);
			BL := to_canvas (BC.BL, scale_factor, true);
			BR := to_canvas (BC.BR, scale_factor, true);

			-- put_line ("TL " & to_string (TL));
			-- put_line ("BL " & to_string (BL));
			-- put_line ("BR " & to_string (BR));

			-- CS clip negative values of U and L ?

			-- horizontal:
			if BL.x <= scrollbar_h_adj.get_value then
				scrollbar_h_adj.set_lower (BL.x);
			else
				scrollbar_h_adj.set_lower (scrollbar_h_adj.get_value);
			end if;

			if BR.x >= scrollbar_h_adj.get_value + scrollbar_h_adj.get_page_size then
				scrollbar_h_adj.set_upper (BR.x);
			else
				scrollbar_h_adj.set_upper (scrollbar_h_adj.get_value + scrollbar_h_adj.get_page_size);
			end if;

			
			-- vertical:
			if TL.y <= scrollbar_v_adj.get_value then
				scrollbar_v_adj.set_lower (TL.y);
			else
				scrollbar_v_adj.set_lower (scrollbar_v_adj.get_value);
			end if;

			if BL.y >= scrollbar_v_adj.get_value + scrollbar_v_adj.get_page_size then
				scrollbar_v_adj.set_upper (BL.y);
			else
				scrollbar_v_adj.set_upper (scrollbar_v_adj.get_value + scrollbar_v_adj.get_page_size);
			end if;
		end update_scrollbar_limits;


		
	begin -- cb_mouse_wheel_rolled
		new_line;
		put_line ("mouse_wheel_rolled");
		put_line (" center " & to_string (mp));
		put_line (" center " & to_string (Z));
		-- put_line (" direction " & gdk_scroll_direction'image (direction));


		-- If CTRL is being pressed, zoom in or out:
		if (event.state and accel_mask) = control_mask then

			case direction is
				when SCROLL_UP =>
					increase_scale;
					put_line ("zoom in  " & to_string (scale_factor));
					
				when SCROLL_DOWN => 
					decrease_scale;
					put_line ("zoom out " & to_string (scale_factor));
					
				when others => null;
			end case;

			compute_translate_offset;
			refresh (canvas);

			update_scrollbar_limits;
		end if;
		
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
		-- put_line ("cb_draw " & image (clock));
		
		set_line_width (context, 1.0);
		set_source_rgb (context, 1.0, 0.0, 0.0);

		
		-- put_line ("object position " & to_string (object.lower_left_corner));

		cp := to_canvas (object.lower_left_corner, scale_factor, true);
		
		-- Draw the rectangle:
		rectangle (context, 
			cp.x, cp.y,	-- lower left corner
			gdouble (object.width)  * gdouble  (scale_factor),  -- width
			gdouble (object.height) * gdouble (-scale_factor)); -- height

		stroke (context);
		
		set_source_rgb (context, 0.0, 1.0, 0.0);
		
		move_to (context,
			cp.x, cp.y + gdouble (object.height) * gdouble (-scale_factor) * 0.5);

		line_to (context,
			cp.x + gdouble (object.width) * gdouble (scale_factor), 
			cp.y + gdouble (object.height) * gdouble (-scale_factor) * 0.5);
		
		stroke (context);

		-- destroy (context); -- exception assertion failed ...
		
		return event_handled;
	end cb_draw;

	
end callbacks;

