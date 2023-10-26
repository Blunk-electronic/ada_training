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
		put_line ("cb_terminate");
		gtk.main.main_quit;
	end cb_terminate;


	procedure cb_focus_win (
		main_window : access gtk_window_record'class) 
	is begin
		put_line ("cb_focus_win");
	end cb_focus_win;

	
	function cb_button_pressed_win (
		window	: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean
	is
		use glib;
		event_handled : boolean := true;
		point : constant type_point_canvas := (event.x, event.y);
	begin
		null;
		
		-- -- Output the button id, x and y position:
		put_line ("cb_button_pressed_win ");
		-- 	& " button " & guint'image (event.button)
		-- 	& to_string (point));

		return event_handled;
	end cb_button_pressed_win;



	
	procedure update_scrollbar_limits (
		bounding_box_corners	: in type_area_corners;
		scale_factor			: in type_scale_factor)
	is
		TL, BL, BR : type_point_canvas;
		scratch : gdouble;
		
	begin
		-- Convert the corners of the bounding-box to canvas coordinates:
		TL := to_canvas (bounding_box_corners.TL, scale_factor, true);
		BL := to_canvas (bounding_box_corners.BL, scale_factor, true);
		BR := to_canvas (bounding_box_corners.BR, scale_factor, true);

		-- put_line ("TL " & to_string (TL));
		-- put_line ("BL " & to_string (BL));
		-- put_line ("BR " & to_string (BR));

		-- CS clip negative values of U and L ?


		-- horizontal:

		-- The left end of the scrollbar is the same as the position
		-- (value) of the scrollbar.
		-- If the left edge of the bounding-box is farther to the
		-- left than the left end of the bar, then the lower limit
		-- moves to the left. It assumes the value of the left edge
		-- of the bounding-box:
		if BL.x <= scrollbar_h_adj.get_value then
			scrollbar_h_adj.set_lower (BL.x);
		else
		-- If the left edge of the box is farther to the right than
		-- the left end of the bar, then the lower limit can not be
		-- moved further to the right. So the lower limit can at most assume
		-- the value of the left end of the bar:
			scrollbar_h_adj.set_lower (scrollbar_h_adj.get_value);
		end if;

		-- The right end of the scrollbar is the sum of its position (value)
		-- and its length (page size):
		scratch := scrollbar_h_adj.get_value + scrollbar_h_adj.get_page_size;
		-- If the right edge of the bounding-box is farther to the
		-- right than the right end of the bar, then the upper limit
		-- moves to the right. It assumes the value of the right edge
		-- of the bounding-box:
		if BR.x >= scratch then
			scrollbar_h_adj.set_upper (BR.x);
		else
		-- If the right edge of the box is farther to the left than
		-- the right end of the bar, then the upper limit can not be
		-- moved further to the left. So the upper limit can at most assume
		-- the value of the right end of the bar:
			scrollbar_h_adj.set_upper (scratch);
		end if;

		
		-- vertical:

		-- The upper end of the scrollbar is the same as the position
		-- (value) of the scrollbar.
		-- If the upper edge of the bounding-box is higher
		-- than the upper end of the bar, then the lower limit
		-- moves upwards. It assumes the value of the upper edge
		-- of the bounding-box:		
		if TL.y <= scrollbar_v_adj.get_value then
			scrollbar_v_adj.set_lower (TL.y);
		else
		-- If the upper edge of the box is below
		-- the upper end of the bar, then the lower limit can not be
		-- moved further upwards. So the lower limit can at most assume
		-- the value of the upper end of the bar:
			scrollbar_v_adj.set_lower (scrollbar_v_adj.get_value);
		end if;

		-- The lower end of the scrollbar is the sum of its position (value)
		-- and its length (page size):
		scratch := scrollbar_v_adj.get_value + scrollbar_v_adj.get_page_size;
		-- If the lower edge of the bounding-box is below the
		-- lower end of the bar, then the upper limit
		-- moves further downwards. It assumes the value of the lower edge
		-- of the bounding-box:
		if BL.y >= scratch then
			scrollbar_v_adj.set_upper (BL.y);
		else
		-- If the lower edge of the box is above
		-- the lower end of the bar, then the upper limit can not be
		-- moved further downwards. So the upper limit can at most assume
		-- the value of the lower end of the bar:
			scrollbar_v_adj.set_upper (scratch);
		end if;

	end update_scrollbar_limits;


	-- dv_2 : gdouble := 0.0;

	
		
	procedure cb_main_window_size_allocate (
		window		: access gtk_widget_record'class;
		allocation	: gtk_allocation)
	is 
		-- The current scale factor:
		S1 : constant type_scale_factor := scale_factor;

		-- Each time ths procedure is called, the argument "allocation"
		-- provides the new size of the main window. Later this size will 
		-- be compared with the old size (stored in global 
		-- variable main_window_size):
		new_size : constant type_window_size := (
			width	=> positive (allocation.width),
			height	=> positive (allocation.height));

		-- This is the difference between new width and old width:
		dW : gdouble;

		-- This is the difference between new height and old height:
		dH : gdouble;

		
		-- NOTE: At the end of this procedure, a redraw is called automatically.
		-- No need for an extra call of "refresh (canvas)".

		-- This function computes the canvas point right in the center
		-- of the visible area. The computation bases solely on the
		-- current value and page size of the scrollbars.
		-- NOTE: This function is probably useless.
		function get_center
			return type_point_canvas
		is
			result : type_point_canvas;
		begin
			result.x := scrollbar_h_adj.get_value + scrollbar_h_adj.get_page_size * 0.5;
			result.y := scrollbar_v_adj.get_value + scrollbar_v_adj.get_page_size * 0.5;
			return result;
		end get_center;
		
			
		-- This function computes the the new scale factor S2 from the current 
		-- scale factor S1, length_old and length_new. The formula used is:
		--
		--      length_new * S1
		-- S2 = ---------------
		--        length_old
		--
		function to_scale_factor (
			length_old, length_new : in positive)
			return type_scale_factor -- S2
		is 
			type type_float is digits 6 range 0.0 .. 100_000.0; 
			-- CS: Upper limit might require adjustments for very large screens.
			
			L1 : type_float := type_float (length_old);
			L2 : type_float := type_float (length_new);
		begin
			-- put_line ("L2:" & type_float'image (L2));
			-- put_line ("L1:" & type_float'image (L1));

			-- The return is S2:
			return type_scale_factor (L2 / L1) * S1;
			-- return type_scale_factor (L2 / L1);
		end to_scale_factor;
		


		-- For debugging. Outputs the dimensions and size
		-- changes of the main window:
		procedure show_size is begin
			put_line (" size old (w/h): " 
				& positive'image (main_window_size.width)
				& " /" & positive'image (main_window_size.height));
			
			put_line (" size new (w/h): " 
				& positive'image (new_size.width)
				& " /" & positive'image (new_size.height));

			put_line (" dW : " & gdouble'image (dW));
			put_line (" dH : " & gdouble'image (dH));

			-- put_line ("S1:" & to_string (S1));
		end show_size;
		
		
		-- When the main window is resized, then it expands away from its top left corner
		-- or it shrinks toward its top-left corner. In both cases the bottom of the
		-- window moves down or up. So the bottom of the canvas must follow the bottom
		-- of the main window. This procedure moves the bottom of the canvas by the same
		-- extent as the bottom of the main window:
		procedure move_canvas_bottom is begin
			-- Approach 1:
			-- One way to move the canvas is to change the y-component of the base_offset.
			-- The drawback is that the aligning appears choppy:
			-- base_offset.y := base_offset.y - dh;
			
			-- Approach 2:
			-- This approach makes the aligning appear much more smoothly. It changes the
			-- allocation of the canvas. It requires the global variable canvas_allocation
			-- to track the allocation of the canvas:
			declare
				L : gtk_allocation;
			begin					
				canvas_allocation.y := canvas_allocation.y + (new_size.height - main_window_size.height);
				-- put_line ("canvas_allocation.y  : " & positive'image (canvas_allocation.y));

				get_allocation (canvas, L);
				L.y := gint (canvas_allocation.y);
				canvas.size_allocate (L);
			end;

		end move_canvas_bottom;
		

		-- This procedure should move the canvas so that the center
		-- remains in the center of the window. 
		-- Related to MODE_ZOOM_CENTER.
		-- This is a construction site (CS). No suitable solution found yet:
		procedure move_center_and_zoom is 
			-- d0_h : gdouble;
			-- dV_h : gdouble;
			-- d : gdouble;
			
			-- a : gtk_allocation;
			-- V2, P2, L2, U2 : gdouble;

			-- The canvas point in the center of the visible area:
			-- Z1: type_point_canvas;

			-- The temporarily canvas point after scaling:
			-- Z2 : type_point_canvas;

			-- C : gdouble;

			-- These are the new scale factors. One is computed by the change
			-- of the width, the other by the change of the height of the window:
			S2W, S2H  : type_scale_factor;

			-- The new scale factor:
			S2 : type_scale_factor;

			-- Get the corners of the bounding-box as it is BEFORE scaling:
			BC : constant type_area_corners := get_corners (bounding_box);

			-- The model point in the center of the visible area:
			-- M : type_point_model := visible_center;
			
		begin
			null;

			-- CS:
			-- Compute two new scale factors: one based on the change of width
			-- and the other based on the change of height:

			S2W := to_scale_factor (main_window_size.width, new_size.width);
			-- put_line ("S2W:" & to_string (S2W));

			S2H := to_scale_factor (main_window_size.height, new_size.height);
			-- put_line ("S2H:" & to_string (S2H));

			-- CS
			-- The idea is that the smaller one of the two scale 
			-- factors has the final say, like:				
			-- S2 := type_scale_factor'min (S2W, S2H);
			-- But this seems not sufficient. For the time being we
			-- use the scale factor derived from the change of width:				
			S2 := S2W;
			
			if S2 < 1.0 then
				S2 := 1.0;
			end if;
			-- S2 := 1.0;
			put_line ("S2:" & to_string (S2));

			
			-- put_line ("center " & to_string (M));
			-- Z1 := to_canvas (M, S1, true);
			-- put_line ("Z1 " & to_string (Z1));
			
			-- Z2 := to_canvas (M, S2, true);
			-- put_line ("Z2 " & to_string (Z2));
			
			-- update_scrollbar_limits (BC, S2);

			-- Z2 := get_center;
			-- put_line ("Z2 " & to_string (Z2));
			-- C := scrollbar_h_adj.get_value + gdouble (new_size.width) * 0.5;
			
			-- L2 := scrollbar_h_adj.get_lower;
			-- U2 := scrollbar_h_adj.get_upper;
			-- C := 0.5 * (U2 - L2) + L2;
			-- put_line ("C : " & gdouble'image (C));
			
			-- dV_h := Z2.x - C;
			-- dV_h := C - Z2.x;
			-- put_line ("dv: " & gdouble'image (dV_h));
			-- V2 := scrollbar_h_adj.get_value + dV_h;
			-- scrollbar_h_adj.set_value (V2);
			
			-- d0_h := scrollbar_h_adj.get_lower - scrollbar_h_adj.get_value;
			-- put_line ("d0_h : " & gdouble'image (d0_h));
			
			-- dV_h := (abs (d0_h) * gdouble (S2)) + d0_h;
			-- put_line ("dV_h : " & gdouble'image (dV_h));

			-- d := dv_h - dv_2;
			-- NOTE: dv_2 is a global variable !
			
			-- put_line ("d    : " & gdouble'image (d));
			-- base_offset.x := base_offset.x - d;
			-- put_line ("boffs: " & gdouble'image (base_offset.x));
			-- dv_2 := dV_h;
			
			-- get_allocation (canvas, a);
			-- a.x := a.x - gint (dV_h);
			-- canvas_allocation.x := natural (dV_h);
			-- a.x := gint (canvas_allocation.x);
			-- put_line ("a.x  : " & gint'image (a.x));
			-- canvas.size_allocate (a);
			
			-- V2 := scrollbar_h_adj.get_value + dV_h;
			-- scrollbar_h_adj.set_value (V2);
			-- put_line ("V2   : " & gdouble'image (V2));

			-- P2 := scrollbar_h_adj.get_page_size - dV_h;
			-- scrollbar_h_adj.set_page_size (P2);
			-- put_line ("P2   : " & gdouble'image (P2));

			-- U2 := scrollbar_h_adj.get_upper + d;
			-- scrollbar_h_adj.set_upper (U2);
			-- put_line ("U2   : " & gdouble'image (U2));

			-- L2 := scrollbar_h_adj.get_lower - d;
			-- scrollbar_h_adj.set_lower (L2);
			-- put_line ("L2   : " & gdouble'image (L2));

			
			-- dv_2 := dV_h;			


			-- update the global scale factor:
			scale_factor := S2;
			
			-- CS clip negative values ?
			show_adjustments_h;
			show_adjustments_v;
			
		end move_center_and_zoom;

		
		-- This procedure moves the canvas so that the center of the visible
		-- area remains in the center.
		-- This procedure is required when zoom mode MODE_KEEP_CENTER is enabled:
		procedure move_center is
		begin
			base_offset.x := base_offset.x + dW * 0.5;
			base_offset.y := base_offset.y + dH * 0.5;
			-- put_line ("F : " & to_string (base_offset));
		end move_center;

		
	begin
		-- put_line ("cb_main_window_size_allocate " & image (clock)); 
		-- put_line ("cb_main_window_size_allocate. (x/y/w/h): " 
		-- 	& gint'image (allocation.x) 
		-- 	& " /" & gint'image (allocation.y)
		-- 	& " /" & gint'image (allocation.width)
		-- 	& " /" & gint'image (allocation.height));

		-- This procedure is called on many occasions. We are interested
		-- only in cases where the size changes. That is when the user moves
		-- the border of the main window or when she maximizes the window.
		-- So we watch for changes of width and height only:
		
		-- Compare the new size with the old size. The global variable 
		-- main_window_size provides the size of the window BEFORE this
		-- procedure has been called. If the size has changed, then we start 
		-- zooming in or out. The zoom center is ths canvas point in the 
		-- center of the visible area:
		if new_size /= main_window_size then
			new_line;
			put_line ("main window size changed");

			-- Opon resizing the main window, the settings of the scrollbars 
			-- (upper, lower and page size) adapt to the size of the canvas. 
			-- But we do NOT want this behaviour. Instead we restore the settings
			-- as they where BEFORE this procedure has been called:
			restore_scrollbar_settings;
			-- show_adjustments_h;
			-- show_adjustments_v;
			
			-- Compute the change of width and height:
			dW := gdouble (new_size.width - main_window_size.width);
			dH := gdouble (new_size.height - main_window_size.height);

			-- for debugging:
			show_size;

			-- Move the canvas so that its bottom follows
			-- the bottom of the main window:
			move_canvas_bottom;
			

			case zoom_mode is
				when MODE_EXPOSE_CANVAS =>
					null; -- nothing more to do
					
				when MODE_KEEP_CENTER =>
					move_center;
					
				when MODE_ZOOM_CENTER =>
					-- CS
					move_center;
					move_center_and_zoom;

			end case;
			
			-- refresh (canvas) is called automatically.
			-- But this call makes the resizing appear more smoothely:
			-- refresh (canvas);
			
			-- Adjust scrollbars:
			backup_scrollbar_settings;

			-- Update the main_window_size which is required
			-- for the next time this procedure is called:
			main_window_size := new_size;

			update_visible_area (canvas);
		end if;
		
	end cb_main_window_size_allocate;



	
	function cb_main_window_configure (
		window		: access gtk_widget_record'class;
		event		: gdk.event.gdk_event_configure)
		return boolean
	is
		result : boolean := false;
	begin
		-- put_line ("cb_main_window_configure " & image (clock)); 
		return result;
	end cb_main_window_configure;


	procedure cb_main_window_realize (
		window	: access gtk_widget_record'class)
	is begin
		put_line ("cb_main_window_realize " & image (clock)); 
	end cb_main_window_realize;
	

	function cb_main_window_state_change (
		window		: access gtk_widget_record'class;
		event		: gdk.event.gdk_event_window_state)
		return boolean
	is
		result : boolean := false;
	begin
		-- put_line ("cb_main_window_state_change " & image (clock)); 
		-- restore_scrollbar_settings;
		return result;
	end cb_main_window_state_change;


	procedure cb_main_window_activate (
		window		: access gtk_window_record'class)
	is begin
		put_line ("cb_main_window_activate " & image (clock)); 
	end cb_main_window_activate;

	
	procedure set_up_main_window is
	begin
		main_window := gtk_window_new (WINDOW_TOPLEVEL);
		main_window.set_title ("Demo Canvas");
		-- main_window.set_border_width (10);

		-- Set the minimum size of the main window basing on the 
		-- bounding-box:
		main_window.set_size_request (
			gint (bounding_box.width),
			gint (bounding_box.height));

		
		-- Set the global main_window_size variable:
		main_window_size := (
			width	=> positive (bounding_box.width),
			height	=> positive (bounding_box.height));
		
		-- CS show main window size

		put_line ("main window zoom mode: " 
			& type_main_window_zoom_mode'image (zoom_mode));
		
		-- connect signals:
		main_window.on_destroy (cb_terminate'access);
		main_window.on_size_allocate (cb_main_window_size_allocate'access);
		main_window.on_button_press_event (cb_button_pressed_win'access);

		main_window.on_configure_event (cb_main_window_configure'access);
		main_window.on_window_state_event (cb_main_window_state_change'access);
		main_window.on_realize (cb_main_window_realize'access);
		main_window.on_activate_default (cb_main_window_activate'access);
		-- main_window.on_activate_focus (cb_focus_win'access);
		-- main_window.set_has_window (false);
		-- main_window.set_redraw_on_allocate (false);
	end set_up_main_window;


	

-- SCROLLED WINDOW:




	
-- SCROLLBARS:

	
	procedure cb_horizontal_moved (
		scrollbar : access gtk_adjustment_record'class)
	is begin
		-- put_line ("horizontal moved " & image (clock));
		null;
		show_adjustments_h;
		update_visible_area (canvas);		
		backup_scrollbar_settings;
	end cb_horizontal_moved;

	
	procedure cb_vertical_moved (
		scrollbar : access gtk_adjustment_record'class)
	is begin		
		-- put_line ("vertical moved " & image (clock));
		null;
		show_adjustments_v;
		update_visible_area (canvas);
		backup_scrollbar_settings;
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
		return event_handled;
	end cb_scrollbar_h_released;


	procedure backup_scrollbar_settings is begin
		scrollbar_h_backup.lower := scrollbar_h_adj.get_lower;
		scrollbar_h_backup.value := scrollbar_h_adj.get_value;
		scrollbar_h_backup.page_size := scrollbar_h_adj.get_page_size;
		scrollbar_h_backup.upper := scrollbar_h_adj.get_upper;

		scrollbar_v_backup.lower := scrollbar_v_adj.get_lower;
		scrollbar_v_backup.value := scrollbar_v_adj.get_value;
		scrollbar_v_backup.page_size := scrollbar_v_adj.get_page_size;
		scrollbar_v_backup.upper := scrollbar_v_adj.get_upper;
	end backup_scrollbar_settings;
	

	procedure restore_scrollbar_settings is begin
		scrollbar_h_adj.set_lower (scrollbar_h_backup.lower);
		scrollbar_h_adj.set_value (scrollbar_h_backup.value);
		scrollbar_h_adj.set_page_size (scrollbar_h_backup.page_size);
		scrollbar_h_adj.set_upper (scrollbar_h_backup.upper);

		scrollbar_v_adj.set_lower (scrollbar_v_backup.lower);
		scrollbar_v_adj.set_value (scrollbar_v_backup.value);
		scrollbar_v_adj.set_page_size (scrollbar_v_backup.page_size);
		scrollbar_v_adj.set_upper (scrollbar_v_backup.upper);
	end restore_scrollbar_settings;


	

	procedure set_up_swin_and_scrollbars is
	begin
		put_line ("set_up_swin_and_scrollbars");
		
		-- Create a scrolled window:
		swin := gtk_scrolled_window_new (hadjustment => null, vadjustment => null);
		-- swin.set_border_width (10);
		-- swin.set_redraw_on_allocate (false);
		
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

	end set_up_swin_and_scrollbars;



	
	procedure show_adjustments_v is 
		v_lower : gdouble := scrollbar_v_adj.get_lower;
		v_value : gdouble := scrollbar_v_adj.get_value;
		v_upper : gdouble := scrollbar_v_adj.get_upper;
		v_page  : gdouble := scrollbar_v_adj.get_page_size;
	begin
		put_line ("vertical scrollbar adjustments:");
		put_line (" lower" & gdouble'image (v_lower));
		put_line (" value" & gdouble'image (v_value));
		put_line (" page " & gdouble'image (v_page));
		put_line (" upper" & gdouble'image (v_upper));
	end show_adjustments_v;
				  

	procedure show_adjustments_h is 
		h_lower : gdouble := scrollbar_h_adj.get_lower;
		h_value : gdouble := scrollbar_h_adj.get_value;
		h_upper : gdouble := scrollbar_h_adj.get_upper;
		h_page  : gdouble := scrollbar_h_adj.get_page_size;
	begin
		put_line ("horizontal scrollbar adjustments:");
		put_line (" lower" & gdouble'image (h_lower));
		put_line (" value" & gdouble'image (h_value));
		put_line (" page " & gdouble'image (h_page));
		put_line (" upper" & gdouble'image (h_upper));
	end show_adjustments_h;

	
	
	procedure prepare_initial_scrollbar_settings is
		debug : boolean := false;
		-- debug : boolean := true;
	begin
		put_line ("prepare initial scrollbar settings");
		
		scrollbar_v_init.upper := - base_offset.y;			
		scrollbar_v_init.lower := scrollbar_v_init.upper - gdouble (bounding_box.height);
		scrollbar_v_init.page_size := gdouble (bounding_box.height);
		scrollbar_v_init.value := scrollbar_v_init.lower;

		if debug then
			put_line (" vertical:");
			put_line ("  lower" & gdouble'image (scrollbar_v_init.lower));
			put_line ("  upper" & gdouble'image (scrollbar_v_init.upper));
			put_line ("  page " & gdouble'image (scrollbar_v_init.page_size));
			put_line ("  value" & gdouble'image (scrollbar_v_init.value));
		end if;
		
		scrollbar_h_init.lower := base_offset.x;
		scrollbar_h_init.upper := scrollbar_h_init.lower + gdouble (bounding_box.width);
		scrollbar_h_init.page_size := gdouble (bounding_box.width);
		scrollbar_h_init.value := scrollbar_h_init.lower;

		if debug then
			put_line (" horizontal:");
			put_line ("  lower" & gdouble'image (scrollbar_h_init.lower));
			put_line ("  upper" & gdouble'image (scrollbar_h_init.upper));
			put_line ("  page " & gdouble'image (scrollbar_h_init.page_size));
			put_line ("  value" & gdouble'image (scrollbar_h_init.value));
		end if;
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

		update_visible_area (canvas); -- updates visible_area and visible_center

		backup_scrollbar_settings;
	end apply_initial_scrollbar_settings;
	

	

	
-- CANVAS:
	
	procedure refresh (
		canvas	: access gtk_widget_record'class)
	is
		drawing_area : constant gtk_drawing_area := gtk_drawing_area (canvas);
	begin
		put_line ("refresh " & image (clock)); 
		drawing_area.queue_draw;
	end refresh;


	procedure cb_canvas_size_allocate (
		canvas		: access gtk_widget_record'class;
		allocation	: gtk_allocation)
	is begin
		null;
		-- new_line;
		-- put_line ("cb_canvas_size_allocate");
		put_line ("cb_canvas_size_allocate. (x/y/w/h): " & gint'image (allocation.x) 
			& " /" & gint'image (allocation.y)
			& " /" & gint'image (allocation.width)
			& " /" & gint'image (allocation.height));

	end cb_canvas_size_allocate;


	
	

	procedure show_canvas_size is 
		width, height : gint;
	begin
		canvas.get_size_request (width, height);
		put_line ("canvas size (w/h):" & gint'image (width) & " /" & gint'image (height));
	end show_canvas_size;

	
	
	procedure set_up_canvas is
		size_x, size_y : gint;
	begin
		put_line ("set_up_canvas");
		
		-- Set up the drawing area:
		gtk_new (canvas);

		-- Connect signals:
		-- canvas.on_realize (cb_canvas_realized'access);
		-- Not required currently.

		-- canvas.on_size_allocate (cb_canvas_size_allocate'access);
		-- The canvas size never changes. So this connection is not required.
		
		-- canvas.set_redraw_on_allocate (false);
		
		-- Set the size of the canvas (in pixels).
		-- It is like the wooden frame around a real-world canvas. 
		size_x := gint (scrollbar_h_init.upper + scrollbar_h_init.lower);
		size_y := gint (scrollbar_v_init.upper + scrollbar_v_init.lower);

		canvas.set_size_request (size_x, size_y); -- unit is pixels

		show_canvas_size;

		
		-- Connect further signals:
		canvas.on_draw (cb_draw_objects'access);
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

	

	procedure update_visible_area (
		canvas	: access gtk_widget_record'class)
	is begin
		-- put_line ("update visible area");
		visible_area := get_visible_area (canvas);
		-- put_line (" visible area " & to_string (visible_area));

		visible_center := get_center (visible_area);
		-- put_line (" visible center " & to_string (visible_center));
	end update_visible_area;

	
	
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


	procedure cb_canvas_realized (
		canvas	: access gtk_widget_record'class)
	is
	begin
		put_line ("cb_canvas_realized");
	end cb_canvas_realized;



	
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

		-- The direction at which the operator is turning the wheel:
		D : constant gdk_scroll_direction := event.direction;

		-- The given point on the canvas where the operator is zooming in or out:
		Z1 : constant type_point_canvas := (event.x, event.y);

		-- The corresponding virtual model-point
		-- according to the CURRENT (old) scale_factor:
		M : constant type_point_model := to_model (Z1, scale_factor);

		
		-- After changing the scale_factor, the translate_offset must
		-- be calculated anew. When the actual drawing takes place (see function cb_draw)
		-- then the drawing will be dragged back by the translate_offset
		-- so that the operator gets the impression of a zoom-into or zoom-out effect.
		-- Without applying a translate_offset the drawing would be appearing as 
		-- expanding to the upper-right (on zoom-in) or shrinking toward the lower-left:
		procedure compute_translate_offset is 
			Z2 : type_point_canvas;
		begin			
			-- Compute the prospected canvas-point according to the new scale_factor:
			Z2 := to_canvas (M, scale_factor);
			-- put_line ("Z after scale   " & to_string (Z2));

			-- This is the offset from the given canvas-point to the prospected
			-- canvas-point. The offset must be multiplied by -1 because the
			-- drawing must be dragged-back to the given pointer position:
			T.x := -(Z2.x - Z1.x);
			T.y := -(Z2.y - Z1.y);
			
			put_line (" T offset    " & to_string (T));
		end compute_translate_offset;


		

		-- Get the corners of the bounding-box as it is BEFORE scaling:
		BC : constant type_area_corners := get_corners (bounding_box);


		
	begin -- cb_mouse_wheel_rolled
		new_line;
		put_line ("mouse_wheel_rolled");
		-- put_line (" direction " & gdk_scroll_direction'image (direction));


		-- If CTRL is being pressed, zoom in or out:
		if (event.state and accel_mask) = control_mask then

			put_line (" zoom center (M)   " & to_string (M));
			put_line (" zoom center (Z1) " & to_string (Z1));
			put_line (" scale old" & to_string (scale_factor));
			
			case D is
				when SCROLL_UP =>
					increase_scale;
					put_line (" zoom in");
					
				when SCROLL_DOWN => 
					decrease_scale;
					put_line (" zoom out");
					
				when others => null;
			end case;

			-- scale_factor := SM * SW;
			put_line (" scale new" & to_string (scale_factor));
			compute_translate_offset;
			
			update_scrollbar_limits (BC, scale_factor);
			backup_scrollbar_settings;

			-- schedule a redraw:
			refresh (canvas);

			update_visible_area (canvas);

			
		elsif (event.state and accel_mask) = shift_mask then
			case D is
				when SCROLL_UP =>
					put_line (" scroll right");
					
				when SCROLL_DOWN => 
					put_line (" scroll left");
					
				when others => null;
			end case;


		else
			case D is
				when SCROLL_UP =>
					put_line (" scroll up");
					scrollbar_v_adj.set_value (scrollbar_v_adj.get_value + 10.0 * gdouble (scale_factor));
				when SCROLL_DOWN => 
					put_line (" scroll down");
					scrollbar_v_adj.set_value (scrollbar_v_adj.get_value - 10.0 * gdouble (scale_factor));
					
				when others => null;
			end case;
			
			show_adjustments_v;
		end if;
		
		return event_handled;
	end cb_mouse_wheel_rolled;


	
	
	function cb_draw_objects (
		canvas	: access gtk_widget_record'class;
		context	: in cairo_context)
		return boolean
	is
		event_handled : boolean := true;
		cp : type_point_canvas;
	begin
		-- new_line;
		-- put_line ("cb_draw " & image (clock));
		
		-- NOTE: In a real project, the database that contains
		-- all objects must be parsed here. One object after another
		-- must be drawn. But since this is a demo,
		-- we have just a single object (a rectangle) do deal with.
		
		
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
	end cb_draw_objects;

	
end callbacks;

