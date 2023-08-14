with glib;
with gdk.types;
with gdk.types.keysyms;
with gtk.accel_group;
with gtk.enums;					use gtk.enums;
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

	
	
	procedure adjust_canvas_size
	is begin
		-- Expand the canvas if scale is greater or equal 1.
		-- Otherwise the canvas assumes default size:
		if scale_factor >= 1.0 then

			canvas.set_size_request (
				gint (1000.0 * gdouble (scale_factor)),
				gint (1000.0 * gdouble (scale_factor)));

		else
			canvas.set_size_request (
				gint (1000.0),
				gint (1000.0));

		end if;
		-- show_adjustments;
	end adjust_canvas_size;



	procedure init_limits is
	begin
		scrollbar_v_initial_lower := -base_offset_default.y - gdouble (bounding_box_height);
		scrollbar_v_adj.set_lower (scrollbar_v_initial_lower);

		scrollbar_v_initial_upper := 3800.0 - scrollbar_v_initial_lower;
		scrollbar_v_adj.set_upper (scrollbar_v_initial_upper);

		scrollbar_v_adj.set_page_size (gdouble (bounding_box_height));
		scrollbar_v_adj.set_value (1800.0);
	end init_limits;
	
	
	
	
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


	UM, LM : gdouble := 0.0;
	
	procedure compute_LM_UM is begin
		LM := scrollbar_v_adj.get_value - scrollbar_v_adj.get_lower;
		UM := scrollbar_v_adj.get_upper - (scrollbar_v_adj.get_value + scrollbar_v_adj.get_page_size);

		put_line ("LM" & gdouble'image (LM));
		put_line ("UM" & gdouble'image (UM));
	end compute_LM_UM;

	
	function cb_scrollbar_v_released (
		bar		: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean
	is
		event_handled : boolean := false;
	begin
		-- put_line ("cb_scrollbar_v_released");
		compute_LM_UM;
		return event_handled;
	end cb_scrollbar_v_released;


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

	
	procedure cb_size_allocate (
		canvas		: access gtk_widget_record'class;
		allocation	: gtk_allocation)
	is
	begin
		null;
		-- new_line;
		-- put_line ("cb_size_allocate");
		put_line ("cb_size_allocate. pos: " & gint'image (allocation.x) 
			& " /" & gint'image (allocation.y)
			& "    width/height:" & gint'image (allocation.width)
			& " /" & gint'image (allocation.height));

	end cb_size_allocate;

	

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

	
	
	function cb_button_pressed (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean
	is
		use glib;
		event_handled : boolean := false;
		point : constant type_point_canvas := (event.x, event.y);

		mp : constant type_point_model := to_model (point, scale_factor, translate_offset, base_offset);
	begin
		-- Output the button id, x and y position:
		put_line ("cb_button_pressed "
			& " button " & guint'image (event.button)
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
		mp : constant type_point_model := to_model (cp, scale_factor, translate_offset, base_offset);
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

		-- init_GH_old := true;
		return event_handled;
	end cb_key_pressed;


	procedure cb_realized (
		canvas	: access gtk_widget_record'class)
	is
	begin
		put_line ("canvas realized");
	end cb_realized;


	-- last_zoom_point : type_point_canvas;
	-- zoom_point_changed : boolean := true;

	
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
		-- CS rename to zoom_point or ZP

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


		y_ratio : gdouble;

		procedure compute_y_ratio is
			y : gdouble;
		begin
			-- Here the visible area in y begins downwards:
			y := cp.y - scrollbar_v_adj.get_value;
			put_line ("y " & gdouble'image (y));

			y_ratio := y / gdouble (bounding_box_height);
			put_line ("r " & gdouble'image (y_ratio));
		end compute_y_ratio;


		Z : type_zoom;
		S1 : constant type_scale_factor := scale_factor;
		S2 : type_scale_factor;
		
		G1, G2, H1, H2 : gdouble;
		
		
		procedure compute_G1_H1 is
			SP : constant gdouble := gdouble (bounding_box_height) * gdouble (scale_factor);
		begin
			G1 := SP * y_ratio;
			H1 := SP - G1;
		end;

		
		procedure compute_G2_H2 is
			SP : constant gdouble := gdouble (bounding_box_height) * gdouble (scale_factor);
		begin
			G2 := SP * y_ratio;
			H2 := SP - G2;
		end;

		
		
		procedure set_v_limits is
			dl, du : gdouble;
			L, U : gdouble;
		begin
			dl := G2 - G1;
			du := H2 - H1;

			put_line ("dl" & gdouble'image (dl));
			put_line ("du" & gdouble'image (du));

			case Z is
				when ZOOM_OUT =>
					-- du is negative or equal zero
					if UM < abs (du) then
						put_line ("A");
						U := scrollbar_v_adj.get_upper - UM; -- U moves upwards by the available margin
						scrollbar_v_adj.set_upper (U);
					else
						put_line ("B");
						U := scrollbar_v_adj.get_upper - abs (du);
						scrollbar_v_adj.set_upper (U); -- U moves upwards by du
					end if;

					-- dl is negative or equal zero
					if LM < abs (dl) then
						put_line ("C");
						L := scrollbar_v_adj.get_lower + LM;  -- L moves downwards by the available margin
						scrollbar_v_adj.set_lower (L);
					else
						put_line ("D");
						L := scrollbar_v_adj.get_lower + abs (dl);
						scrollbar_v_adj.set_lower (L); -- L moves downwards by dl
					end if;


					
				when ZOOM_IN =>
					-- du is greater or equal zero
					U := scrollbar_v_adj.get_upper + du;
					scrollbar_v_adj.set_upper (U); -- U moves downwards

					-- dl is greater or equal zero
					L := scrollbar_v_adj.get_lower - dl;
					scrollbar_v_adj.set_lower (L); -- L moves upwards

			end case;
			
				-- CS clip negative values ?
				-- CS L must not be greater than scrollbar_v_initial_lower ?
				-- if L > scrollbar_v_initial_lower then
				-- 	L := scrollbar_v_initial_lower;
				-- end if;
				-- NO !
				
				-- CS U must not be less than scrollbar_v_initial_upper ?
				-- if U < scrollbar_v_initial_upper then
				-- 	U := scrollbar_v_initial_upper;
				-- end if;
				-- NO !

				-- if scale_factor < 1.0 then
				-- 	scrollbar_v_adj.set_page_size (gdouble (bounding_box_height) * gdouble (scale_factor));
				-- end if;
				
			show_adjustments;

			compute_LM_UM;
		end set_v_limits;

		
	begin
		-- Output the time and the gdk_key_type (which is
		-- just a number (see gdk.types und gdk.types.keysyms)):
		new_line;
		put_line ("mouse_wheel_rolled "
			& to_string (cp)
			& " direction " & gdk_scroll_direction'image (direction));


		-- If CTRL is being pressed, zoom in or out:
		if (event.state and accel_mask) = control_mask then

			compute_y_ratio;
			
			case direction is
				when SCROLL_UP =>
					Z := ZOOM_IN;
					compute_G1_H1;
					increase_scale;
					S2 := scale_factor;
					put_line ("zoom in  " & to_string (scale_factor));
					compute_translate_offset;
					refresh (canvas);
					compute_G2_H2;
					set_v_limits;
					
				when SCROLL_DOWN => 
					Z := ZOOM_OUT;
					compute_G1_H1;
					decrease_scale;
					S2 := scale_factor;
					put_line ("zoom out " & to_string (scale_factor));
					compute_translate_offset;
					refresh (canvas);
					compute_G2_H2;
					set_v_limits;
					
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
		cp : type_point_canvas;
	begin
		-- new_line;
		-- put_line ("cb_draw " & image (clock));
		
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

