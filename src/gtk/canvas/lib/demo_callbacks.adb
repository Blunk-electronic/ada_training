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
with demo_conversions;			use demo_conversions;
with demo_base_offset;			use demo_base_offset;
with demo_translate_offset;		use demo_translate_offset;
with demo_scrolled_window;		use demo_scrolled_window;
with demo_visible_area;
with demo_coordinates_display;	use demo_coordinates_display;
with demo_drawing_origin;
with demo_scale_factor;			use demo_scale_factor;
with demo_cursor;				use demo_cursor;
with demo_objects;				use demo_objects;

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
		-- CS
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
		point : constant type_logical_pixels_vector :=
			(to_lp (event.x), to_lp (event.y));
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

	
		
		
	procedure cb_main_window_size_allocate (
		window		: access gtk_widget_record'class;
		allocation	: gtk_allocation)
	is 
	begin
		null;		
		-- put_line ("cb_main_window_size_allocate " & image (clock)); 

		-- put_line ("cb_window_size_allocate. (x/y/w/h): " 
		-- 	& gint'image (allocation.x) 
		-- 	& " /" & gint'image (allocation.y)
		-- 	& " /" & gint'image (allocation.width)
		-- 	& " /" & gint'image (allocation.height));		
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
		main_window.on_size_allocate (cb_main_window_size_allocate'access);
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
		dW : type_logical_pixels;

		-- This is the difference between new height and old height:
		dH : type_logical_pixels;


		-- For debugging. Outputs the dimensions and size
		-- changes of the main window:
		procedure show_size is begin
			put_line (" size old (w/h): " 
				& positive'image (swin_size.width)
				& " /" & positive'image (swin_size.height));
			
			put_line (" size new (w/h): " 
				& positive'image (new_size.width)
				& " /" & positive'image (new_size.height));

			put_line (" dW : " & to_string (dW));
			put_line (" dH : " & to_string (dH));

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
			dW := type_logical_pixels (new_size.width - swin_size.width);
			dH := type_logical_pixels (new_size.height - swin_size.height);

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
		-- show_adjustments_h;
		refresh (canvas);
	end cb_horizontal_moved;

	
	procedure cb_vertical_moved (
		scrollbar : access gtk_adjustment_record'class)
	is begin		
		-- put_line ("vertical moved " & image (clock));
		-- show_adjustments_v;
		refresh (canvas);
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

		canvas.on_draw (cb_draw'access);
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
		cp : constant type_logical_pixels_vector := 
			(to_lp (event.x), to_lp (event.y));

		-- Convert the canvas point to the corresponding
		-- real model point:
		mp : constant type_vector_model := to_model (
			point 	=> cp,
			scale	=> S,
			real	=> true);

		-- CS: For some reason the value of the scrollbars
		-- must be saved and restored if the canvas grabs the focus:
		h, v : type_logical_pixels;
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
		h := to_lp (scrollbar_h_adj.get_value);
		v := to_lp (scrollbar_v_adj.get_value);
		-- CS: backup_scrollbar_settings does not work for some reason.
		-- put_line (to_string (v));
		
		canvas.grab_focus;

		scrollbar_h_adj.set_value (to_gdouble (h));
		scrollbar_v_adj.set_value (to_gdouble (v));
		-- CS: restore_scrollbar_settings does not work for some reason.
		-- put_line (to_string (v));


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
		cp : constant type_logical_pixels_vector := 
			(to_lp (event.x), to_lp (event.y));

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

		cp : constant type_logical_pixels_vector := 
			(to_lp (event.x), to_lp (event.y));

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
			Z : constant type_logical_pixels_vector := 
				(to_lp (event.x), to_lp (event.y));

			-- The corners of the bounding-box on the canvas before 
			-- and after zooming:
			C1, C2 : type_bounding_box_corners;
			S1 : constant type_zoom_factor := S;
			
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
			-- place (see function cb_draw)
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
			
			v1, dv, v2 : type_logical_pixels;

			-- This procedure computes the amount
			-- by which the scrollbar value is to be changed:
			procedure set_delta is begin
				null;
				-- CS: This is emperical for the time being.
				-- Rework required.
				dv := 10.0 * type_logical_pixels (S);
			end set_delta;
			
		begin
			if debug then
				put_line (" " & type_scroll_direction'image (direction));
			end if;
			

			case direction is
				when SCROLL_DOWN =>
					-- Get the current value of the scrollbar:
					v1 := to_lp (scrollbar_v_adj.get_value);

					-- Compute the amout by which the 
					-- scrollbar is to be moved:
					set_delta;
					
					-- Compute the new value of the scrollbar:
					v2 := v1 + dv;

					-- Set the new value of the scrollbar:
					scrollbar_v_adj.set_value (to_gdouble (v2));

					
				when SCROLL_UP =>
					v1 := to_lp (scrollbar_v_adj.get_value);
					set_delta;
					v2 := v1 - dv;
					scrollbar_v_adj.set_value (to_gdouble (v2));

				when SCROLL_RIGHT =>
					v1 := to_lp (scrollbar_h_adj.get_value);
					set_delta;
					v2 := v1 + dv;
					scrollbar_h_adj.set_value (to_gdouble (v2));
					
				when SCROLL_LEFT =>
					v1 := to_lp (scrollbar_h_adj.get_value);
					set_delta;
					v2 := v1 - dv;
					scrollbar_h_adj.set_value (to_gdouble (v2));

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



	
	function cb_draw (
		canvas		: access gtk_widget_record'class;
		context_in	: in cairo_context)
		return boolean
	is
		event_handled : boolean := true;

		use demo_visible_area;
		
	begin
		-- new_line;
		-- put_line ("cb_draw " & image (clock));

		-- Update the global context:
		context := context_in;

		
		-- Update the global visible_area:
		visible_area := get_visible_area (canvas);
		-- put_line (" visible " & to_string (visible_area));

		-- Set the background color:
		-- set_source_rgb (context, 0.0, 0.0, 0.0); -- black
		set_source_rgb (context, 1.0, 1.0, 1.0); -- white
		paint (context);

		-- The ends of all kinds of lines are round:
		set_line_cap (context, cairo_line_cap_round);

		demo_grid.draw_grid;		
		demo_drawing_origin.draw_origin;
		draw_cursor;
		draw_zoom_area;
		demo_frame.draw_drawing_frame;		
		draw_objects;		
		
		return event_handled;
	end cb_draw;

	
end demo_callbacks;

