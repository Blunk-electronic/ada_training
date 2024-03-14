------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                    CALLBACK FUNCTIONS AND PROCEDURES                     --
--                                                                          --
--                               B o d y                                    --
--                                                                          --
-- Copyright (C) 2024                                                       --
-- Mario Blunk / Blunk electronic                                           --
-- Buchfinkenweg 3 / 99097 Erfurt / Germany                                 --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
------------------------------------------------------------------------------

--   For correct displaying set tab width in your editor to 4.

--   The two letters "CS" indicate a "construction site" where things are not
--   finished yet or intended for the future.

--   Please send your questions and comments to:
--
--   info@blunk-electronic.de
--   or visit <http://www.blunk-electronic.de> for more contact data
--
--   history of changes:
--

with gdk.types;
with gdk.types.keysyms;
with gtk.accel_group;
with gtk.enums;					use gtk.enums;
with gtk.misc;					use gtk.misc;

with ada.text_io;				use ada.text_io;
with ada.calendar;				use ada.calendar;
with ada.calendar.formatting;	use ada.calendar.formatting;

with gtk.main;					use gtk.main;

with demo_grid;
with demo_frame;
with demo_bounding_box;			use demo_bounding_box;
with demo_conversions;			use demo_conversions;
with demo_base_offset;			use demo_base_offset;
with demo_translate_offset;		use demo_translate_offset;
with demo_visibility;
with demo_scrolled_window;		use demo_scrolled_window;
with demo_visible_area;
with demo_coordinates_display;	use demo_coordinates_display;
with demo_primitive_draw_ops;
with demo_scale_factor;			use demo_scale_factor;


package body demo_callbacks is
	
	
	
	procedure cb_zoom_to_fit (
		button : access gtk_button_record'class)
	is
		-- debug : boolean := true;
		debug : boolean := false;
	begin
		put_line ("cb_zoom_to_fit");

		zoom_to_fit_all;
	end cb_zoom_to_fit;

	

	procedure cb_zoom_area (
		button : access gtk_button_record'class)
	is
		-- debug : boolean := true;
		debug : boolean := false;
	begin
		put_line ("cb_zoom_area");

		zoom_area.active := true;
	end cb_zoom_area;

	

	procedure cb_add (
		button : access gtk_button_record'class)
	is begin
		put_line ("cb_add");
		add_object;

		-- Redraw the canvas:
		refresh (canvas);
	end cb_add;

	
	procedure cb_delete (
		button : access gtk_button_record'class)
	is begin
		put_line ("cb_delete");
		delete_object;

		-- Redraw the canvas:
		refresh (canvas);
	end cb_delete;

	
	procedure cb_move (
		button : access gtk_button_record'class)
	is begin
		put_line ("cb_move");
	end cb_move;


	

	procedure cb_export (
		button : access gtk_button_record'class)
	is
	begin
		put_line ("cb_export");

		-- CS
	end cb_export;


	
	
	
-- MAIN WINDOW:
	
	procedure cb_terminate (
		window : access gtk_widget_record'class) 
	is begin
		put_line ("cb_terminate");
		gtk.main.main_quit;
	end cb_terminate;


	procedure cb_window_focus (
		window : access gtk_window_record'class) 
	is begin
		put_line ("cb_window_focus");
	end cb_window_focus;

	
	function cb_window_button_pressed (
		window	: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean
	is
		use glib;
		event_handled : boolean := true;

		-- The point where the operator has clicked:
		point : constant type_vector_gdouble := (event.x, event.y);
	begin
		null;
		
		-- Output the button id, x and y position:
		put_line ("cb_window_button_pressed "
		 	& "button" & guint'image (event.button) & " "
		 	& to_string (point));
		
		return event_handled;
	end cb_window_button_pressed;



	function cb_window_key_pressed (
		window	: access gtk_widget_record'class;
		event	: gdk_event_key)
		return boolean
	is
		event_handled : boolean := false;

		use gdk.types;		
		use gdk.types.keysyms;
		
		key_ctrl	: gdk_modifier_type := event.state and control_mask;
		key_shift	: gdk_modifier_type := event.state and shift_mask;
		key			: gdk_key_type := event.keyval;

	begin
		-- Output the the gdk_key_type (which is
		-- just a number (see gdk.types und gdk.types.keysyms)):
		put_line ("cb_window_key_pressed "
			& " key " & gdk_key_type'image (event.keyval));

		if key_ctrl = control_mask then 
			case key is

				when others => null;
			end case;

		else
			case key is
				when GDK_ESCAPE =>
					-- Here the commands to abort any pending 
					-- operations should be placed:
					
					-- Abort the zoom-to-area operation:
					reset_zoom_area;

					-- Do not pass this event further
					-- to widgets down the chain.
					-- Prosssing the event stops here.
					event_handled := true;
					

				when GDK_F5 =>
					zoom_to_fit_all;

					-- Do not pass this event further
					-- to widgets down the chain.
					-- Prosssing the event stops here.
					event_handled := true;

					
				when others => null;
			end case;
		end if;
		
		return event_handled;
	end cb_window_key_pressed;

	
		
		
	procedure cb_window_size_allocate (
		window		: access gtk_widget_record'class;
		allocation	: gtk_allocation)
	is 
	begin
		null;
		
		-- put_line ("cb_window_size_allocate " & image (clock)); 

		-- put_line ("cb_window_size_allocate. (x/y/w/h): " 
		-- 	& gint'image (allocation.x) 
		-- 	& " /" & gint'image (allocation.y)
		-- 	& " /" & gint'image (allocation.width)
		-- 	& " /" & gint'image (allocation.height));
		
	end cb_window_size_allocate;



	
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
		null;
		-- put_line ("cb_main_window_realize " & image (clock)); 
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
		null;
		-- put_line ("cb_main_window_activate " & image (clock)); 
	end cb_main_window_activate;


	procedure set_up_command_buttons is
		use demo_buttons;
	begin
		put_line ("set_up_command_buttons");

		create_buttons;

		-- Connect button signals with subprograms:
		button_zoom_fit.on_clicked (cb_zoom_to_fit'access);		
		button_zoom_area.on_clicked (cb_zoom_area'access);
		button_add.on_clicked (cb_add'access);
		button_delete.on_clicked (cb_delete'access);
		button_move.on_clicked (cb_move'access);
		button_export.on_clicked (cb_export'access);

	end set_up_command_buttons;

	
	
	procedure set_up_main_window is begin
		put_line ("set_up_main_window");

		create_window; -- incl. boxes and a separator
	
		
		-- connect signals:
		main_window.on_destroy (cb_terminate'access);
		main_window.on_size_allocate (cb_window_size_allocate'access);
		main_window.on_button_press_event (cb_window_button_pressed'access);
		main_window.on_key_press_event (cb_window_key_pressed'access);
		main_window.on_configure_event (cb_main_window_configure'access);
		
		main_window.on_window_state_event (
			cb_main_window_state_change'access);
		
		main_window.on_realize (cb_main_window_realize'access);
		main_window.on_activate_default (cb_main_window_activate'access);

		-- Not used:
		-- main_window.on_activate_focus (cb_window_focus'access);

		set_up_command_buttons;

	end set_up_main_window;



	
	
	procedure cb_swin_size_allocate (
		swin		: access gtk_widget_record'class;
		allocation	: gtk_allocation)
	is 
		use demo_visible_area;
		
		-- Each time ths procedure is called, the argument "allocation"
		-- provides the new size of the scrolled window. Later this size will 
		-- be compared with the old size (stored in global 
		-- variable scrolled_window_size):
		new_size : constant type_window_size := (
			width	=> positive (allocation.width),
			height	=> positive (allocation.height));

		-- This is the difference between new width and old width:
		dW : gdouble;

		-- This is the difference between new height and old height:
		dH : gdouble;


		-- For debugging. Outputs the dimensions and size
		-- changes of the main window:
		procedure show_size is begin
			put_line (" size old (w/h): " 
				& positive'image (swin_size.width)
				& " /" & positive'image (swin_size.height));
			
			put_line (" size new (w/h): " 
				& positive'image (new_size.width)
				& " /" & positive'image (new_size.height));

			put_line (" dW : " & gdouble'image (dW));
			put_line (" dH : " & gdouble'image (dH));

			-- put_line ("S1:" & to_string (S1));
		end show_size;
		
		
		-- When the scrolled window is resized, then it expands away
		-- from its top left corner or it shrinks toward its top-left
		-- corner. In both cases the bottom of the
		-- window moves down or up. So the bottom of the canvas must 
		-- follow the bottom of the scrolled window. This procedure 
		-- moves the bottom of the canvas by the same
		-- extent as the bottom of the scrolled window:
		procedure move_canvas_bottom is begin
			-- Approach 1:
			-- One way to move the canvas is to change the y-component
			-- of the base-offset.
			F.y := F.y - dh;

			-- Schedule a refresh to make the size change appear smoothly:
			refresh (canvas);
			
			-- Approach 2: -- CS never tried
			-- Modify the y-component of the translate-offset
		end move_canvas_bottom;
		

		

		-- This procedure zooms to the area, stored in last_visible_area,
		-- so that it fits into the current scrolled window.
		-- It is required for MODE_3_ZOOM_FIT:
		procedure zoom_visible_area is 
			-- Get the corners of the bounding-box on the canvas before 
			-- and after zooming:
			C1, C2 : type_bounding_box_corners;			
		begin
			C1 := get_bounding_box_corners;

			-- Reset the translate-offset:
			T := (0.0, 0.0);			

			-- Fit the last visible area into the current
			-- scrolled window:
			zoom_to_fit (last_visible_area);

			C2 := get_bounding_box_corners;
			update_scrollbar_limits (C1, C2);
			backup_scrollbar_settings;			
		end zoom_visible_area;

		
		-- This procedure moves the canvas so that the center of the visible
		-- area remains in the center.
		-- This procedure is required when zoom mode MODE_KEEP_CENTER is 
		-- enabled:
		procedure move_center is
		begin
			F.x := F.x + dW * 0.5;
			F.y := F.y + dH * 0.5;
			-- put_line ("F : " & to_string (F));
		end move_center;

		
	begin -- cb_swin_size_allocate
		
		-- put_line ("cb_swin_size_allocate " & image (clock)); 
		-- put_line ("cb_swin_size_allocate. (x/y/w/h): " 
		-- 	& gint'image (allocation.x) 
		-- 	& " /" & gint'image (allocation.y)
		-- 	& " /" & gint'image (allocation.width)
		-- 	& " /" & gint'image (allocation.height));

		-- This procedure is called on many occasions. We are interested
		-- only in cases where the size changes.
		-- So we watch for changes of width and height only:
		
		-- Compare the new size with the old size. The global variable 
		-- swin_size provides the size of the window BEFORE this
		-- procedure has been called. If the size has changed, then proceed
		-- with other actions. If the size has not changed, then nothing 
		-- happens:
		if new_size /= swin_size then
			new_line;
			put_line ("scrolled window size changed");

			-- Opon resizing the scrolled window, the settings of the 
			-- scrollbars (upper, lower and page size) adapt to the size of
			-- the scrolled window. But we do NOT want this behaviour. 
			-- Instead we restore the settings
			-- as they where BEFORE this procedure has been called:
			restore_scrollbar_settings;
			-- show_adjustments_h;
			-- show_adjustments_v;
			
			-- Compute the change of width and height:
			dW := gdouble (new_size.width - swin_size.width);
			dH := gdouble (new_size.height - swin_size.height);

			-- for debugging:
			-- show_size;

			-- Move the canvas so that its bottom follows
			-- the bottom of the scrolled window:
			move_canvas_bottom;
			

			case zoom_mode is
				when MODE_1_EXPOSE_CANVAS =>
					null; -- nothing more to do
					
				when MODE_2_KEEP_CENTER =>
					move_center;
					
				when MODE_3_ZOOM_FIT =>
					zoom_visible_area;

			end case;
			

			-- Update the swin_size which is required
			-- for the next time this procedure is called:
			swin_size := new_size;

		end if;
	end cb_swin_size_allocate;


	

	procedure set_up_swin_and_scrollbars is	begin
		put_line ("set_up_swin_and_scrollbars");

		create_scrolled_window_and_scrollbars;		

		
		-- connect signals:
		swin.on_size_allocate (cb_swin_size_allocate'access);
		-- After executing procedure cb_swin_size_allocate
		-- the canvas is refreshed (similar to refresh (canvas)) 
		-- automatically.

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

		
		update_cursor_coordinates;
	end set_up_swin_and_scrollbars;


	
	
	procedure cb_horizontal_moved (
		scrollbar : access gtk_adjustment_record'class)
	is begin
		-- put_line ("horizontal moved " & image (clock));
		null;
		-- show_adjustments_h;

		-- CS do not remove, might be required some day:
		-- update_visible_area (canvas);		
		refresh (canvas);
		-- backup_scrollbar_settings;
	end cb_horizontal_moved;

	
	procedure cb_vertical_moved (
		scrollbar : access gtk_adjustment_record'class)
	is begin		
		-- put_line ("vertical moved " & image (clock));
		null;
		-- show_adjustments_v;

		-- CS do not remove, might be required some day:
		-- update_visible_area (canvas);
		refresh (canvas);
		-- backup_scrollbar_settings;
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
		use demo_visible_area;
		event_handled : boolean := false;
	begin
		-- put_line ("cb_scrollbar_v_released");
		backup_scrollbar_settings;

		backup_visible_area (get_visible_area (canvas));
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
		use demo_visible_area;
		event_handled : boolean := false;
	begin
		-- put_line ("cb_scrollbar_h_released");
		backup_scrollbar_settings;

		backup_visible_area (get_visible_area (canvas));
		return event_handled;
	end cb_scrollbar_h_released;



	
-- CANVAS:
	

	procedure cb_canvas_size_allocate (
		canvas		: access gtk_widget_record'class;
		allocation	: gtk_allocation)
	is begin
		null;
		-- new_line;
		-- put_line ("cb_canvas_size_allocate");

		-- put_line ("cb_canvas_size_allocate. (x/y/w/h): " 
		--  & gint'image (allocation.x) 
		-- 	& " /" & gint'image (allocation.y)
		-- 	& " /" & gint'image (allocation.width)
		-- 	& " /" & gint'image (allocation.height));
  
	end cb_canvas_size_allocate;


	
	
	procedure set_up_canvas is begin
		put_line ("set_up_canvas");

		create_canvas;
		
		-- Connect signals:

		-- Not used:
		-- canvas.on_size_allocate (cb_canvas_size_allocate'access);
		-- canvas.set_redraw_on_allocate (false);

		canvas.on_draw (cb_draw_objects'access);
		-- NOTE: No context is declared here, because the canvas widget
		-- passes its own context to the callback procedure cb_draw.
		
		canvas.on_button_press_event (cb_canvas_button_pressed'access);
		canvas.on_button_release_event (cb_canvas_button_released'access);
		canvas.on_motion_notify_event (cb_canvas_mouse_moved'access);
		canvas.on_scroll_event (cb_mouse_wheel_rolled'access);
		canvas.on_key_press_event (cb_canvas_key_pressed'access);

	end set_up_canvas;


	
	
	
	function cb_canvas_button_pressed (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean
	is
		use demo_grid;
		use glib;
		event_handled : boolean := true;

		-- This is the point in the canvas where the operator
		-- has clicked:
		cp : constant type_vector_gdouble := (event.x, event.y);

		-- Convert the canvas point to the corresponding
		-- real model point:
		mp : constant type_vector_model := to_model (
			point 	=> cp,
			scale	=> S,
			real	=> true);

		-- CS: For some reason the value of the scrollbars
		-- must be saved and restored if the canvas grabs the focus:
		h, v : gdouble;
		-- A solution might be:
		-- <https://stackoverflow.com/questions/26693042/
		-- gtkscrolledwindow-disable-scroll-to-focused-child>
		-- or
		-- <https://discourse.gnome.org/t/disable-auto-scrolling-in-
		-- gtkscrolledwindow-when-grab-focus-in-children/13058>
	begin
		put_line ("cb_canvas_button_pressed");

		-- Output the button id, x and y position:
		-- put_line ("cb_canvas_button_pressed "
		-- 	& " button" & guint'image (event.button) & " "
		-- 	& to_string (cp));

		-- Output the model point in the terminal:
		put_line (to_string (mp));


		-- Set the focus on the canvas,
		-- But first save the scrollbar values:
		h := scrollbar_h_adj.get_value;
		v := scrollbar_v_adj.get_value;
		-- CS: backup_scrollbar_settings does not work for some reason.
		-- put_line (gdouble'image (v));
		
		canvas.grab_focus;

		scrollbar_h_adj.set_value (h);
		scrollbar_v_adj.set_value (v);
		-- CS: restore_scrollbar_settings does not work for some reason.
		-- put_line (gdouble'image (v));


		-- If no zoom-to-area operation is active, then
		-- just place the cursor where the operator has clicked the canvas.
		-- If the operator has started a zoom-to-area operation, then
		-- set the first corner of the area:
		if zoom_area.active then
			zoom_area.k1 := mp;
			--put_line ("zoom area k1: " & to_string (zoom_area.k1));

			-- For the routine that draws a rectangle around the
			-- selected area: Indicate that a selection has started 
			-- and a start point has been defined:
			zoom_area.started := true;
			zoom_area.l1 := cp;
			--put_line ("zoom area l1: " & to_string (zoom_area.l1));
		else
		-- Otherwise move the cursor to the nearest grid point:
			move_cursor (snap_to_grid (mp));
		end if;

		
		refresh (canvas);
		
		return event_handled;
	end cb_canvas_button_pressed;




	function cb_canvas_button_released (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean
	is
		use demo_visible_area;
		use glib;
		
		event_handled : boolean := true;

		debug : boolean := false;
		

		-- This is the point in the canvas where the operator
		-- released the button:
		cp : constant type_vector_gdouble := (event.x, event.y);

		-- Convert the canvas point to the corresponding
		-- real model point:
		mp : constant type_vector_model := to_model (
			point 	=> cp,
			scale	=> S,
			real	=> true);

		-- The corners of the bounding-box on the canvas before 
		-- and after zooming:
		C1, C2 : type_bounding_box_corners;
		
	begin
		put_line ("cb_canvas_button_released");

		
		-- Output the button id, x and y position:
		-- put_line ("cb_canvas_button_pressed "
		-- 	& " button" & guint'image (event.button) & " "
		-- 	& to_string (cp));

		-- Output the model point in the terminal:
		-- put_line (to_string (mp));

		-- Move the cursor to the nearest grid point:
		-- move_cursor (snap_to_grid (mp));


		-- If the operator is finishing a zoom-to-area operation,
		-- then the actual area of interest is computed here
		-- and passed to procedure zoom_to_fit.
		-- If start and end point of the area are equal,
		-- then nothing happens here.
		if zoom_area.active then
			C1 := get_bounding_box_corners;

			-- Set the second corner of the zoom-area:
			zoom_area.k2 := mp;

			-- Compute the area from the corner points k1 and k2
			-- if they are different. Otherwise nothing happens here:
			if zoom_area.k1 /= zoom_area.k2 then
				
				if debug then
					put_line ("zoom area c1: " & to_string (zoom_area.k1));
					put_line ("zoom area c2: " & to_string (zoom_area.k2));
				end if;


				-- x-position:
				if zoom_area.k1.x < zoom_area.k2.x then
					zoom_area.area.position.x := zoom_area.k1.x;
				else
					zoom_area.area.position.x := zoom_area.k2.x;
				end if;

				-- y-position:
				if zoom_area.k1.y < zoom_area.k2.y then
					zoom_area.area.position.y := zoom_area.k1.y;
				else
					zoom_area.area.position.y := zoom_area.k2.y;
				end if;

				-- width and height:
				zoom_area.area.width  := 
					abs (zoom_area.k2.x - zoom_area.k1.x);
				
				zoom_area.area.height := 
					abs (zoom_area.k2.y - zoom_area.k1.y);

				if debug then
					put_line ("zoom " & to_string (zoom_area.area));
				end if;


				
				-- Reset the translate-offset:
				T := (0.0, 0.0);			
				zoom_to_fit (zoom_area.area);

				C2 := get_bounding_box_corners;
				update_scrollbar_limits (C1, C2);
				backup_scrollbar_settings;

				-- The operation comes to an end here:
				zoom_area.active := false;

				-- For the routine that draws a rectangle around the
				-- selected area: Indicate that the rectangle shall
				-- no longer be drawn:
				zoom_area.started := false;


				backup_visible_area (zoom_area.area);
			end if;
		end if;

		
		refresh (canvas);
		
		return event_handled;
	end cb_canvas_button_released;


	
	
	
	function cb_canvas_mouse_moved (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_motion)
		return boolean
	is
		use demo_coordinates_display;
		
		use glib;
		event_handled : boolean := true;

		cp : constant type_vector_gdouble := (event.x, event.y);

		-- Get the real model coordinates:
		mp : constant type_vector_model := to_model (cp, S, true);
	begin
		-- put_line ("cb_canvas_mouse_moved");

		-- output on the terminal:
		-- Output the x/y position of the pointer
		-- in logical and model coordinates:
		-- put_line (
			-- to_string (cp)
			-- & " " & to_string (mp)

		-- Update the coordinates display with the pointer position:
		-- x-axis:
		pointer_x_buf.set_text (to_string (mp.x));
		pointer_x_value.set_buffer (pointer_x_buf);
  
		-- y-axis:
		pointer_y_buf.set_text (to_string (mp.y));
		pointer_y_value.set_buffer (pointer_y_buf);

		update_distances_display;

		-- While a zoom-to-area operation is active,
		-- set the end point of the selected area.
		-- The routine that draws the rectangle uses this
		-- point to compute the rectangle on the fly:
		if zoom_area.active then
			zoom_area.l2 := cp;
			--put_line ("zoom area l2: " & to_string (zoom_area.l2));

			-- The canvas must be refreshed in order to
			-- show the rectangle as the mouse is being moved:
			refresh (canvas);
		end if;
		
		return event_handled;
	end cb_canvas_mouse_moved;



	
	
	function cb_canvas_key_pressed (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_key)
		return boolean
	is
		use demo_visible_area;
		use demo_grid;
		
		event_handled : boolean := true;

		use gdk.types;		
		use gdk.types.keysyms;
		
		key_ctrl	: gdk_modifier_type := event.state and control_mask;
		key_shift	: gdk_modifier_type := event.state and shift_mask;
		key			: gdk_key_type := event.keyval;
		
	begin
		-- Output the the gdk_key_type (which is
		-- just a number (see gdk.types und gdk.types.keysyms)):
		put_line ("cb_canvas_key_pressed "
			& " key " & gdk_key_type'image (event.keyval));

		if key_ctrl = control_mask then 
			case key is
				when GDK_KP_ADD | GDK_PLUS =>
					zoom_on_cursor (ZOOM_IN);

				when GDK_KP_SUBTRACT | GDK_MINUS =>
					zoom_on_cursor (ZOOM_OUT);
					
				when others => null;
			end case;

		else
			case key is
				when GDK_ESCAPE =>
					-- Here the commands to abort any pending 
					-- operations related to the canvas should be placed:

					null;
					
					
				when GDK_Right =>
					move_cursor (DIR_RIGHT);

				when GDK_Left =>
					move_cursor (DIR_LEFT);

				when GDK_Up =>
					move_cursor (DIR_UP);

				when GDK_Down =>
					move_cursor (DIR_DOWN);

				when GDK_HOME | GDK_KP_HOME =>
					-- Move the cursor to the grid point that
					-- is nearest to the center of the visible area:
					put_line ("move cursor to center");
					move_cursor (snap_to_grid (get_center (visible_area)));
					refresh (canvas);

				-- when GDK_F2 =>

					
				when others => null;
			end case;
		end if;
		
		return event_handled;
	end cb_canvas_key_pressed;




	
	function cb_mouse_wheel_rolled (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_scroll)
		return boolean
	is
		--debug : boolean := false;
		debug : boolean := true;
		
		use glib;		
		use gdk.types;
		use gtk.accel_group;
		event_handled : boolean := true;

		accel_mask : constant gdk_modifier_type := 
			get_default_mod_mask;

		-- The direction at which the operator is turning the wheel:
		wheel_direction : constant gdk_scroll_direction :=
			event.direction;


		procedure zoom is
			use demo_visible_area;
			
			-- The given point on the canvas where the operator is 
			-- zooming in or out:
			Z : constant type_vector_gdouble := (event.x, event.y);

			-- The corners of the bounding-box on the canvas before 
			-- and after zooming:
			C1, C2 : type_bounding_box_corners;
			S1 : constant type_scale_factor := S;
			
		begin -- zoom
			-- put_line (" scale old" & to_string (S));

			C1 := get_bounding_box_corners;
			
			case wheel_direction is
				when SCROLL_UP =>
					increase_scale;
					if debug then
						put_line (" zoom in");
					end if;
					update_scale_display;
					
				when SCROLL_DOWN => 
					decrease_scale;
					if debug then
						put_line (" zoom out");
					end if;
					update_scale_display;
					
				when others => null;
			end case;

			
			if debug then
				put_line (" S" & to_string (S));
			end if;
			
			-- After changing the scale-factor, the translate-offset must
			-- be calculated anew. When the actual drawing takes 
			-- place (see function cb_draw_objects)
			-- then the drawing will be dragged back by the 
			-- translate-offset so that the operator gets the impression 
			-- of a zoom-into or zoom-out effect.
			-- Without applying a translate-offset the drawing would be 
			-- appearing as expanding to the upper-right (on zoom-in) 
			-- or shrinking toward the lower-left:
			set_translation_for_zoom (S1, S, Z);

			-- show_adjustments_v;
			-- backup_scrollbar_settings;

			C2 := get_bounding_box_corners;
			update_scrollbar_limits (C1, C2);

			backup_visible_area (get_visible_area (canvas));
			
			-- schedule a redraw:
			refresh (canvas);
		end zoom;


		procedure scroll (
			direction : in type_scroll_direction)
		is
			use demo_visible_area;
			
			v1, dv, v2 : gdouble;

			-- This procedure computes the amount
			-- by which the scrollbar value is to be changed:
			procedure set_delta is begin
				null;
				-- CS: This is emperical for the time being.
				-- Rework required.
				dv := 10.0 * gdouble (S);
			end set_delta;
			
		begin
			if debug then
				put_line (" " & type_scroll_direction'image (direction));
			end if;
			

			case direction is
				when SCROLL_DOWN =>
					-- Get the current value of the scrollbar:
					v1 := scrollbar_v_adj.get_value;

					-- Compute the amout by which the 
					-- scrollbar is to be moved:
					set_delta;
					
					-- Compute the new value of the scrollbar:
					v2 := v1 + dv;

					-- Set the new value of the scrollbar:
					scrollbar_v_adj.set_value (v2);

					
				when SCROLL_UP =>
					v1 := scrollbar_v_adj.get_value;
					set_delta;
					v2 := v1 - dv;
					scrollbar_v_adj.set_value (v2);

				when SCROLL_RIGHT =>
					v1 := scrollbar_h_adj.get_value;
					set_delta;
					v2 := v1 + dv;
					scrollbar_h_adj.set_value (v2);
					
				when SCROLL_LEFT =>
					v1 := scrollbar_h_adj.get_value;
					set_delta;
					v2 := v1 - dv;
					scrollbar_h_adj.set_value (v2);

				-- CS clip ?
			end case;

			backup_visible_area (get_visible_area (canvas));
		end scroll;
		
		
	begin -- cb_mouse_wheel_rolled

		if debug then
			put_line ("cb_mouse_wheel_rolled");
			-- put_line (" direction " 
			-- & gdk_scroll_direction'image (wheel_direction));
		end if;


		-- If CTRL is being pressed, then zoom in or out:
		if (event.state and accel_mask) = control_mask then
			zoom;

		-- If SHIFT is being pressed, then scroll up or down:
		elsif (event.state and accel_mask) = shift_mask then
			case wheel_direction is
				when SCROLL_UP =>
					scroll (SCROLL_RIGHT);
					
				when SCROLL_DOWN => 
					scroll (SCROLL_LEFT);
					
				when others => null;
			end case;

		-- If no key is being pressed, then scroll right or left:
		else
			case wheel_direction is
				when SCROLL_UP =>
					scroll (SCROLL_UP);

				when SCROLL_DOWN => 
					scroll (SCROLL_DOWN);
					
				when others => null;
			end case;
		end if;

		backup_scrollbar_settings;
		
		-- update_visible_area (canvas);
		
		return event_handled;
	end cb_mouse_wheel_rolled;



	
	function cb_draw_objects (
		canvas	: access gtk_widget_record'class;
		context	: in cairo_context)
		return boolean
	is
		event_handled : boolean := true;

		-- This procedure draws the origin. The origin is a small
		-- cross at model position (0;0). This procedure does not
		-- check whether the lines of the cross are inside the visible
		-- area. Since it is about two simple lines we draw them
		-- always:
		procedure draw_origin is
			cp : type_vector_gdouble := to_canvas (origin, S, true);
		begin
			set_source_rgb (context, 0.5, 0.5, 0.5); -- gray
			set_line_width (context, origin_linewidth);

			-- Draw the horizontal line from left to right:
			move_to (context, cp.x - origin_size, cp.y);
			line_to (context, cp.x + origin_size, cp.y);

			-- Draw the vertical line from top to bottom:
			move_to (context, cp.x, cp.y - origin_size);
			line_to (context, cp.x, cp.y + origin_size);
			stroke (context);
		end draw_origin;
		
		
		-- This procedure draws the grid in the visible area.
		-- Outside the visible area nothing is drawn in order to save time.
		-- The procedure works as follows:
		-- 1. Define the begin and end of the visible area in 
		--    x and y direction.
		-- 2. Find the first column that comes after the begin of 
		--    the visible area (in x direction).
		-- 3. Find the last column that comes before the end of the 
		--    visible area (in x direction).
		-- 4. Find the first row that comes after the begin of the 
		--    visible area (in y direction).
		-- 5. Find the last row that comes before the end of the 
		--    visible area (in y direction).
		-- 6. Draw the grid as dots or lines, depending on the user specified
		--    settings.
		procedure draw_grid is
			use demo_grid;
			use demo_visible_area;
			
			type type_float_grid is new float; -- CS refinement required

			-- X-AXIS:

			-- The first and the last column:
			x1, x2 : type_distance_model;

			-- The start and the end of the visible area:
			ax1 : constant type_float_grid := 
				type_float_grid (visible_area.position.x);
			
			ax2 : constant type_float_grid := 
				ax1 + type_float_grid (visible_area.width);

			-- The grid spacing:
			gx : constant type_float_grid := 
				type_float_grid (grid.spacing.x);

			
			-- Y-AXIS:

			-- The first and the last row:
			y1, y2 : type_distance_model;

			-- The start and the end of the visible area:
			ay1 : constant type_float_grid := 
				type_float_grid (visible_area.position.y);
			
			ay2 : constant type_float_grid := 
				ay1 + type_float_grid (visible_area.height);

			-- The grid spacing:
			gy : constant type_float_grid := 
				type_float_grid (grid.spacing.y);

			c : type_float_grid;

			-- debug : boolean := false;

			
			procedure compute_first_and_last_column is begin
				-- Compute the first column:
				-- put_line (" ax1 " & type_float_grid'image (ax1));
				c := type_float_grid'floor (ax1 / gx);
				x1 := type_distance_model ((gx * c) + gx);
				-- put_line (" x1  " & type_distance_model'image (x1));

				-- Compute the last column:
				-- put_line (" ax2 " & type_float_grid'image (ax2));
				c := type_float_grid'floor (ax2 / gx);
				x2 := type_distance_model (gx * c);
				-- put_line (" x2  " & type_distance_model'image (x2));
			end compute_first_and_last_column;


			procedure compute_first_and_last_row is begin
				-- Compute the first row:
				-- put_line (" ay1 " & type_float_grid'image (ay1));
				c := type_float_grid'floor (ay1 / gy);
				y1 := type_distance_model ((gy * c) + gy);
				-- put_line (" y1  " & type_distance_model'image (y1));

				-- Compute the last row:
				-- put_line (" ay2 " & type_float_grid'image (ay2));
				c := type_float_grid'floor (ay2 / gy);
				y2 := type_distance_model (gy * c);
				-- put_line (" y2  " & type_distance_model'image (y2));
			end compute_first_and_last_row;
			

			-- This procedure draws the dots of the grid:
			-- 1. Assemble from the first row and the first colum a real
			--    model point MP.
			-- 2. Advance PM from row to row and column to column in a 
			--    matrix like order.
			-- 3. Draw a very small circle, which will appear like a dot,
			--    (or alternatively a very small cross) at MP.
			procedure draw_dots is 
				MP : type_vector_model;
				CP : type_vector_gdouble;
			begin
				-- Set the linewidth of the dots:
				set_line_width (context, grid_width_dots);
				
				-- Compose a model point from the first column and 
				-- the first row:
				MP := (x1, y1);

				-- Advance PM from column to column:
				while MP.x <= x2 loop

					-- Advance PM from row to row:
					MP.y := y1;
					while MP.y <= y2 loop
						-- Convert the current real model point MP to a
						-- point on the canvas:
						CP := to_canvas (MP, S, true);

						-- Draw a very small circle with its center at CP:
						-- arc (context, CP.x, CP.y, 
						-- 	 radius => grid_radius_dots, angle1 => 0.0, 
						--    angle2 => 6.3);
						-- stroke (context);

						-- Alternatively, draw a very small cross at CP.
						-- This could be more efficient than a circle:
						
						-- horizontal line:
						move_to (context, CP.x - grid_cross_arm_length, CP.y);
						line_to (context, CP.x + grid_cross_arm_length, CP.y);
						stroke (context);

						-- vertical line:
						move_to (context, CP.x, CP.y - grid_cross_arm_length);
						line_to (context, CP.x, CP.y + grid_cross_arm_length);
						stroke (context);
												
						-- Advance one row up:
						MP.y := MP.y + grid.spacing.y;
					end loop;

					-- Advance one column to the right:
					MP.x := MP.x + grid.spacing.x;
				end loop;
			end draw_dots;


			-- This procedure draws the lines of the grid:
			procedure draw_lines is 
				MP1 : type_vector_model;
				MP2 : type_vector_model;

				CP1 : type_vector_gdouble;
				CP2 : type_vector_gdouble;

				ax1f : type_distance_model := visible_area.position.x;
				ax2f : type_distance_model := ax1f + visible_area.width;
				
				ay1f : type_distance_model := visible_area.position.y;
				ay2f : type_distance_model := ay1f + visible_area.height;
			begin
				-- Set the linewidth of the lines:
				set_line_width (context, grid_width_lines);
				
				-- VERTICAL LINES:

				-- All vertical lines start at the bottom of 
				-- the visible area:
				MP1 := (x1, ay1f);

				-- All vertical lines end at the top of the 
				-- visible area:
				MP2 := (x1, ay2f);

				-- The first vertical line runs along the first column. 
				-- The last vertical line runs along the last column.
				-- This loop advances from one column to the next and
				-- draws a vertical line:
				while MP1.x <= x2 loop
					CP1 := to_canvas (MP1, S, true);
					CP2 := to_canvas (MP2, S, true);
					
					move_to (context, CP1.x, CP1.y);
					line_to (context, CP2.x, CP2.y);

					MP1.x := MP1.x + grid.spacing.x;
					MP2.x := MP2.x + grid.spacing.x;
					stroke (context);
				end loop;

				
				-- HORIZONTAL LINES:

				-- All horizontal lines start at the left edge of the 
				-- visible area:
				MP1 := (ax1f, y1);

				-- All horizontal lines end at the right edge of the 
				-- visible area:
				MP2 := (ax2f, y1);

				-- The first horizontal line runs along the first row. 
				-- The last horizontal line runs along the last row.
				-- This loop advances from one row to the next and
				-- draws a horizontal line:
				while MP1.y <= y2 loop
					CP1 := to_canvas (MP1, S, true);
					CP2 := to_canvas (MP2, S, true);
					
					move_to (context, CP1.x, CP1.y);
					line_to (context, CP2.x, CP2.y);

					MP1.y := MP1.y + grid.spacing.y;
					MP2.y := MP2.y + grid.spacing.y;
					stroke (context);
				end loop;
			end draw_lines;
			

		begin -- draw_grid
			-- put_line ("draw_grid");
			compute_first_and_last_column;
			compute_first_and_last_row;

			-- Set the color of the grid:
			set_source_rgb (context, 0.5, 0.5, 0.5); -- gray

			case grid.style is
				when STYLE_DOTS =>
					draw_dots;

				when STYLE_LINES =>
					draw_lines;
			end case;
		end draw_grid;


		-- This procedure draws the cursor at its current
		-- position. To keep things simple, the cursor is
		-- drawn always, regardless whether it is in the visible
		-- area or not:
		procedure draw_cursor is
			cp : type_vector_gdouble := 
				to_canvas (cursor.position, S, true);

			-- These are the start and stop positions for the
			-- horizontal lines:
			h1, h2, h3, h4 : gdouble;

			-- These are the start and stop positions for the
			-- vertical lines:
			v1, v2, v3, v4 : gdouble;

			-- This is the total length of an arm:
			l : constant gdouble := cursor.length_1 + cursor.length_2;
		begin
			set_source_rgb (context, 0.5, 0.5, 0.5); -- gray

			-- Compute the start and stop positions:
			h1 := cp.x - l;
			h2 := cp.x - cursor.length_1;
			h3 := cp.x + cursor.length_1;
			h4 := cp.x + l;
			
			v1 := cp.y - l;
			v2 := cp.y - cursor.length_1;
			v3 := cp.y + cursor.length_1;
			v4 := cp.y + l;

			-- Draw the horizontal line from left to right:
			-- thick
			set_line_width (context, cursor.linewidth_2);
			move_to (context, h1, cp.y);
			line_to (context, h2, cp.y);
			stroke (context);

			-- thin
			set_line_width (context, cursor.linewidth_1);
			move_to (context, h2, cp.y);
			line_to (context, h3, cp.y);
			stroke (context);

			-- thick
			set_line_width (context, cursor.linewidth_2);
			move_to (context, h3, cp.y);
			line_to (context, h4, cp.y);
			stroke (context);
			
			-- Draw the vertical line from top to bottom:
			-- thick
			move_to (context, cp.x, v1);
			line_to (context, cp.x, v2);
			stroke (context);

			-- thin
			set_line_width (context, cursor.linewidth_1);
			move_to (context, cp.x, v2);
			line_to (context, cp.x, v3);
			stroke (context);

			-- thick
			set_line_width (context, cursor.linewidth_2);
			move_to (context, cp.x, v3);
			line_to (context, cp.x, v4);
			stroke (context);

			-- arc
			set_line_width (context, cursor.linewidth_1);
			arc (context, cp.x, cp.y, 
				radius => cursor.radius, angle1 => 0.0, angle2 => 6.3);
			stroke (context);

			-- CS: To improve performance on drawing, it might help
			-- to draw all objects which have a thin line first, then
			-- all object with a thick line.
		end draw_cursor;
		

		-- If a zoom-to-area operation has started, then
		-- this procedure draws the rectangle around the
		-- area to be zoomed at.
		-- The rectangle is drawn directly on the cairo_context.
		procedure draw_zoom_area is
			x, y : gdouble;
			w, h : gdouble;

			l1 : type_vector_gdouble renames zoom_area.l1;
			l2 : type_vector_gdouble renames zoom_area.l2;
		begin
			if zoom_area.started then

				-- Set the color of the rectangle:
				set_source_rgb (context, 0.5, 0.5, 0.5); -- gray

				-- Compute the position and dimensions of
				-- the rectangle:

				-- x-position:
				if l1.x < l2.x then
					x := l1.x;
				else
					x := l2.x;
				end if;

				-- y-position:
				if l1.y < l2.y then
					y := l1.y;
				else
					y := l2.y;
				end if;

				-- width and height:
				w := abs (l1.x - l2.x);
				h := abs (l1.y - l2.y);

				set_line_width (context, zoom_area_linewidth);
				
				rectangle (context, x, y, w, h);
				stroke (context);
			end if;
		end draw_zoom_area;

		

		-- Draws all primitive objects of the drawing frame
		-- and draws them one by one:
		procedure draw_drawing_frame is
			use demo_primitive_draw_ops;
			use demo_frame;
			use pac_lines;
			
			

			procedure query_line (lc : in pac_lines.cursor) is
				-- The candidate line being handled:
				line : type_line renames element (lc);
			begin
				--put_line ("query_line");
				draw_line (context, line, drawing_frame.p);					
			end query_line;
	
			
		begin
			--put_line ("draw_drawing_frame");

			-- Set the color:
			set_source_rgb (context, 0.5, 0.5, 0.5); -- gray

			drawing_frame.lines.iterate (query_line'access);			
			-- CS texts
			
		end draw_drawing_frame;


		

		-- Draws all model objects. Parses the model database
		-- and draws objects one by one:
		procedure draw_objects is
			use demo_primitive_draw_ops;
			use pac_lines;
			use pac_circles;
			use pac_objects;


			procedure query_object (oc : in pac_objects.cursor) is
				object : type_complex_object renames element (oc);

				procedure query_line (lc : in pac_lines.cursor) is
					line : type_line renames element (lc);
				begin
					--put_line ("query_line");
					draw_line (context, line, object.p);					
				end query_line;

				
				procedure query_circle (cc : in pac_circles.cursor) is
					circle : type_circle renames element (cc);
				begin
					-- put_line ("query_circle");
					draw_circle (context, circle, object.p);					
				end query_circle;

				
			begin
				--put_line ("query_object");
				object.lines.iterate (query_line'access);
				object.circles.iterate (query_circle'access);
			end query_object;
			
		begin
			--put_line ("draw_objects");
			
			-- Set the color:
			set_source_rgb (context, 1.0, 0.0, 0.0);

			-- CS draw origin

			objects_database.iterate (query_object'access);
		end draw_objects;


		
		use demo_grid;
		use demo_visible_area;
		
		
	begin -- cb_draw_objects
		-- new_line;
		-- put_line ("cb_draw_objects " & image (clock));

		-- CS if context is global then do:
		-- context_global := context;

		-- show_adjustments_v;
		
		-- Update the global visible_area:
		visible_area := get_visible_area (canvas);
		-- put_line (" visible " & to_string (visible_area));

		-- Set the background color:
		-- set_source_rgb (context, 0.0, 0.0, 0.0); -- black
		set_source_rgb (context, 1.0, 1.0, 1.0); -- white
		paint (context);

		-- The ends of all kinds of lines are round:
		set_line_cap (context, cairo_line_cap_round);

		
		-- Draw the grid if it is enabled and if the spacing
		-- is greater than the minimal required spacing:
		if grid.on = GRID_ON and then
			get_grid_spacing (grid) >= grid_spacing_min then
			draw_grid;
		end if; -- CS move this stuff to procedure draw_grid.
		
		draw_origin;

		draw_cursor;

		draw_zoom_area;

		draw_drawing_frame;
		
		draw_objects;
		
		
		return event_handled;
	end cb_draw_objects;

	
end demo_callbacks;
