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

with glib;
with gdk.types;
with gdk.types.keysyms;
with gtk.accel_group;
with gtk.enums;					use gtk.enums;
with gtk.misc;					use gtk.misc;

with ada.text_io;				use ada.text_io;
with ada.calendar;				use ada.calendar;
with ada.calendar.formatting;	use ada.calendar.formatting;

with gtk.main;					use gtk.main;


package body callbacks is

	procedure set_base_offset is
		debug : boolean := false;
		
		x, y : gdouble;

		-- The maximum scale factor:
		S_max : constant gdouble := gdouble (type_scale_factor'last);

		-- The width and height of the bounding-box:
		Bh : constant gdouble := gdouble (bounding_box.height);
		Bw : constant gdouble := gdouble (bounding_box.width);
	begin
		x :=   Bw * (S_max - 1.0);
		y := - Bh * S_max;

		-- Set the base-offset:
		F := (x, y);

		-- Output a warning if the base-offset is outside
		-- the canvas dimensions:
		if  x >   gdouble (canvas_size.width) or
			y < - gdouble (canvas_size.height) then

			put_line ("WARNING: base-offset outside canvas !");
			put_line (" F: " & to_string (F));
		end if;
		

		if debug then
			put_line ("base offset: " & to_string (F));
		end if;
	end set_base_offset;

	

	procedure set_translation_for_zoom (
		S1	: in type_scale_factor;
		S2	: in type_scale_factor;
		Z1	: in type_vector_gdouble)
	is 
		debug : boolean := false;
		
		-- Compute the virtual model-point
		-- according to the scale factor before zoom:
		M : constant type_vector_model := to_model (Z1, S1);

		Z2 : type_vector_gdouble;
	begin			
		if debug then
			put_line ("set_translation_for_zoom");
		end if;
		
		-- Compute the prospected canvas-point according to the 
		-- scale factor after zoom:
		Z2 := to_canvas (M, S2);

		-- This is the offset from Z1 to the prospected
		-- point Z2. The offset must be multiplied by -1 because the
		-- drawing must be dragged-back to the given pointer position:
		T.x := -(Z2.x - Z1.x);
		T.y := -(Z2.y - Z1.y);

		if debug then
			put_line (" T: " & to_string (T));
		end if;
	end set_translation_for_zoom;


	procedure set_translation_for_zoom (
		S1	: in type_scale_factor;
		S2	: in type_scale_factor;
		M	: in type_vector_model) -- real model point
	is 
		debug : boolean := false;
		
		-- Compute the canvas point corresponding to the given
		-- real model point with the scale factor before zoom:
		Z1 : constant type_vector_gdouble := to_canvas (M, S1, real => true);

		-- Convert the given model point to a virtual point in the model:
		V : constant type_vector_model := to_virtual (M);
		
		Z2 : type_vector_gdouble;
	begin			
		if debug then
			put_line ("set_translation_for_zoom");
		end if;
		
		-- Compute the prospected canvas-point according to the 
		-- scale factor after zoom:
		Z2 := to_canvas (V, S2);
		-- put_line ("Z2 " & to_string (Z2));

		-- This is the offset from point Z1 to the prospected
		-- point Z2. The offset must be multiplied by -1 because the
		-- drawing must be dragged-back to the given pointer position:
		T.x := -(Z2.x - Z1.x);
		T.y := -(Z2.y - Z1.y);
		
		if debug then
			put_line (" T: " & to_string (T));
		end if;
	end set_translation_for_zoom;

	

	function get_bounding_box_corners
		return type_bounding_box_corners
	is
		result : type_bounding_box_corners;

		-- The corners of the given area in model-coordinates:
		BC : constant type_area_corners := get_corners (bounding_box);

	begin
		-- Convert the corners of the bounding-box to canvas coordinates:
		result.TL := to_canvas (BC.TL, S, true);
		result.TR := to_canvas (BC.TR, S, true);
		result.BL := to_canvas (BC.BL, S, true);
		result.BR := to_canvas (BC.BR, S, true);
		
		return result;
	end get_bounding_box_corners;

	

	function to_distance (
		d : in type_distance_model)
		return type_distance_gdouble
	is begin
		return gdouble (d) * gdouble (S);
	end to_distance;


	function to_distance (
		d : in type_distance_gdouble)
		return type_distance_model
	is begin
		return type_distance_model (d / gdouble (S));
	end to_distance;
	

	
	function to_model (
		point	: in type_vector_gdouble;
		scale	: in type_scale_factor;
		real 	: in boolean := false)
		return type_vector_model
	is 
		result : type_vector_model;
		debug : boolean := false;
	begin
		if debug then
			put_line ("to_model");
			put_line ("T " & to_string (T));
		end if;
		
		result.x := type_distance_model (( (point.x - T.x) - F.x) / gdouble (scale));
		result.y := type_distance_model ((-(point.y - T.y) - F.y) / gdouble (scale));

		-- If real model coordinates are required, then the result must be compensated
		-- by the bounding-box position:
		if real then
			move_by (result, bounding_box.position);
		end if;
		return result;

		exception
			when constraint_error =>
				put_line ("ERROR: conversion from canvas point to model point failed !");
				put_line (" point " & to_string (point));
				put_line (" scale " & to_string (scale));
				put_line (" T     " & to_string (T));
				put_line (" F     " & to_string (F));
				put_line (" real  " & boolean'image (real));
				raise;						  
	end to_model;
	

	function to_canvas (
		point 	: in type_vector_model;
		scale	: in type_scale_factor;
		real	: in boolean := false)
		return type_vector_gdouble
	is
		P : type_vector_model := point;
		result : type_vector_gdouble;
	begin
		-- If real model coordinates are given, then they must
		-- be compensated by the inverted bounding-box position
		-- in order to get virtual model coordinates:
		if real then
			move_by (P, invert (bounding_box.position));
		end if;
		
		result.x :=  (gdouble (P.x) * gdouble (scale) + F.x);
		result.y := -(gdouble (P.y) * gdouble (scale) + F.y);

		if real then
			result.x := result.x + T.x;
			result.y := result.y + T.y;
		end if;
		
		return result;
	end to_canvas;



	function above_visibility_threshold (
		a : in type_area)
		return boolean
	is
		-- CS: Optimization required. Compiler options ?
		w : constant gdouble := to_distance (a.width);
		h : constant gdouble := to_distance (a.height);
		l : gdouble;
	begin
		-- Get the greatest of w and h:
		l := gdouble'max (w, h);

		if l > visibility_threshold then
			return true;
		else
			return false;
		end if;
		
	end above_visibility_threshold;


	

	function get_grid_spacing (
		grid : in type_grid)
		return gdouble
	is
		sg : constant gdouble := gdouble (S);
		x, y : gdouble;
	begin
		x := gdouble (grid.spacing.x) * sg;
		y := gdouble (grid.spacing.y) * sg;
		return gdouble'min (x, y);
	end get_grid_spacing;


	function to_string (
		size : in type_window_size)
		return string
	is begin
		return "w/h " & positive'image (size.width) 
			& "/" & positive'image (size.height);
	end to_string;
		

	
	
	procedure cb_zoom_to_fit (
		button : access gtk_button_record'class)
	is
		-- debug : boolean := true;
		debug : boolean := false;
	begin
		put_line ("cb_zoom_to_fit");

		zoom_to_fit_all;
	end cb_zoom_to_fit;


	procedure reset_zoom_area is begin
		put_line ("reset_zoom_area");
		zoom_area := (others => <>);
	end reset_zoom_area;
	

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


	
	
	procedure update_cursor_coordinates is begin
		-- x-axis:
		cursor_x_buf.set_text (to_string (cursor.position.x));
		cursor_x_value.set_buffer (cursor_x_buf);
 
		-- y-axis:
		cursor_y_buf.set_text (to_string (cursor.position.y));
		cursor_y_value.set_buffer (cursor_y_buf);
	end update_cursor_coordinates;


	
	
	procedure update_distances_display is 
		px, py : gint; -- the pointer position
		cp : type_vector_gdouble;
		mp : type_vector_model;

		dx, dy : type_distance_model;
		dabs : type_distance_model;
		angle : type_rotation_model;
	begin
		-- Get the current pointer/mouse position:
		canvas.get_pointer (px, py);
		cp := (gdouble (px), gdouble (py));
		
		-- Convert the pointer position to a real
		-- point in the model:
		mp := to_model (cp, S, true);

		-- Compute the relative distance from cursor
		-- to pointer:
		dx := mp.x - cursor.position.x;
		dy := mp.y - cursor.position.y;

		-- Compute the absolute distance from
		-- cursor to pointer:
		dabs := get_distance (
			p1 => (0.0, 0.0),
			p2 => (dx, dy));

		-- Compute the angle of direction from cursor
		-- to pointer:
		angle := get_angle (
			p1 => (0.0, 0.0),
			p2 => (dx, dy));

		
		-- Output the relative distances on the display:

		-- dx:
		distances_dx_buf.set_text (to_string (dx));
		distances_dx_value.set_buffer (distances_dx_buf);

		-- dy:
		distances_dy_buf.set_text (to_string (dy));
		distances_dy_value.set_buffer (distances_dy_buf);

		-- absolute:
		distances_absolute_buf.set_text (to_string (dabs));
		distances_absolute_value.set_buffer (distances_absolute_buf);

		-- angle:
		distances_angle_buf.set_text (to_string (angle));
		distances_angle_value.set_buffer (distances_angle_buf);
	end update_distances_display;


	
	procedure update_scale_display is begin
		scale_buf.set_text (to_string (S));
		scale_value.set_buffer (scale_buf);
	end update_scale_display;

	

	procedure update_grid_display is begin
		-- x-axis:
		grid_x_buf.set_text (to_string (grid.spacing.x));
		grid_x_value.set_buffer (grid_x_buf);

		-- y-axis:
		grid_y_buf.set_text (to_string (grid.spacing.y));
		grid_y_value.set_buffer (grid_y_buf);
	end update_grid_display;

	
	
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

	
	
	procedure update_scrollbar_limits (
		C1, C2 : in type_bounding_box_corners)
	is
		debug : boolean := false;
		scratch : gdouble;

		HL : gdouble := scrollbar_h_adj.get_lower;
		HU : gdouble := scrollbar_h_adj.get_upper;

		VL : gdouble := scrollbar_v_adj.get_lower;
		VU : gdouble := scrollbar_v_adj.get_upper;

		dHL, dHU : gdouble;
		dVL, dVU : gdouble;
	begin
		if debug then
			put_line ("VL     " & gdouble'image (VL));
			put_line ("VU     " & gdouble'image (VU));

			put_line ("C1.TL.y" & gdouble'image (C1.TL.y));
			put_line ("C1.BL.y" & gdouble'image (C1.BL.y));

			put_line ("C2.TL.y" & gdouble'image (C2.TL.y));
			put_line ("C2.BL.y" & gdouble'image (C2.BL.y));
		end if;
		
		dHL := C2.BL.x - C1.BL.x;
		dHU := C2.BR.x - C1.BR.x;

		dVL := C2.TL.y - C1.TL.y;
		dVU := C2.BL.y - C1.BL.y;

		if debug then
			put_line ("dVL    " & gdouble'image (dVL));
			put_line ("dVU    " & gdouble'image (dVU));
		end if;
		

		-- horizontal:

		-- The left end of the scrollbar is the same as the position
		-- (value) of the scrollbar.
		-- If the left edge of the bounding-box is farther to the
		-- left than the left end of the bar, then the lower limit
		-- moves to the left. It assumes the value of the left edge
		-- of the bounding-box:
		HL := HL + dHL;
		if HL <= scrollbar_h_adj.get_value then
			clip_min (HL, 0.0); -- suppress negative value
			scrollbar_h_adj.set_lower (HL);
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
		HU := HU + dHU;
		-- CS clip_max (HU, gdouble (scrolled_window_size.width));
		-- If the right edge of the bounding-box is farther to the
		-- right than the right end of the bar, then the upper limit
		-- moves to the right. It assumes the value of the right edge
		-- of the bounding-box:
		if HU >= scratch then
			scrollbar_h_adj.set_upper (HU);
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
		VL := VL + dVL;
		if VL <= scrollbar_v_adj.get_value then
			clip_min (VL, 0.0); -- suppress negative value
			scrollbar_v_adj.set_lower (VL);
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
		VU := VU + dVU;
		-- CS clip_max (VU, gdouble (scrolled_window_size.height));
		-- If the lower edge of the bounding-box is below the
		-- lower end of the bar, then the upper limit
		-- moves further downwards. It assumes the value of the lower edge
		-- of the bounding-box:
		if VU >= scratch then
			scrollbar_v_adj.set_upper (VU);
		else
		-- If the lower edge of the box is above
		-- the lower end of the bar, then the upper limit can not be
		-- moved further downwards. So the upper limit can at most assume
		-- the value of the lower end of the bar:
			scrollbar_v_adj.set_upper (scratch);
		end if;

		-- show_adjustments_v;
	end update_scrollbar_limits;


	
		
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
	begin
		put_line ("set_up_command_buttons");
		
		gtk_new_vbox (box_v0);
		box_h.pack_start (box_v0, expand => false);


		gtk_new (buttons_table, rows => 5, columns => 1, homogeneous => false);
		-- table.set_col_spacings (50);
		-- table_coordinates.set_border_width (10);

		gtk_new (button_zoom_fit, "ZOOM FIT");
		button_zoom_fit.on_clicked (cb_zoom_to_fit'access);

		gtk_new (button_zoom_area, "ZOOM AREA");
		button_zoom_area.on_clicked (cb_zoom_area'access);
		
		gtk_new (button_add, "ADD");
		button_add.on_clicked (cb_add'access);

		gtk_new (button_delete, "DELETE");
		button_delete.on_clicked (cb_delete'access);

		gtk_new (button_move, "MOVE");
		button_move.on_clicked (cb_move'access);
		
		gtk_new (button_export, "EXPORT");
		button_export.on_clicked (cb_export'access);

		-- CS add other buttons
		
		
		-- The table shall not expand downward:
		box_v0.pack_start (buttons_table, expand => false);

		
		buttons_table.attach (button_zoom_fit,
			left_attach => 0, right_attach => 1,
			top_attach  => 0, bottom_attach => 1);

		buttons_table.attach (button_zoom_area,
			left_attach => 0, right_attach => 1,
			top_attach  => 1, bottom_attach => 2);
		
		buttons_table.attach (button_add,
			left_attach => 0, right_attach => 1,
			top_attach  => 2, bottom_attach => 3);

		buttons_table.attach (button_delete,
			left_attach => 0, right_attach => 1,
			top_attach  => 3, bottom_attach => 4);

		buttons_table.attach (button_move,
			left_attach => 0, right_attach => 1,
			top_attach  => 4, bottom_attach => 5);

		buttons_table.attach (button_export,
			left_attach => 0, right_attach => 1,
			top_attach  => 5, bottom_attach => 6);
		
	end set_up_command_buttons;

	
	
	procedure set_up_main_window is begin
		put_line ("set_up_main_window");
		
		main_window := gtk_window_new (WINDOW_TOPLEVEL);
		main_window.set_title ("Demo Canvas");
		main_window.set_border_width (10);

		-- CS: Set the minimum size of the main window ?
		-- CS show main window size
		-- main_window.set_size_request (1000, 500);
		
		-- connect signals:
		main_window.on_destroy (cb_terminate'access);
		main_window.on_size_allocate (cb_window_size_allocate'access);
		main_window.on_button_press_event (cb_window_button_pressed'access);
		main_window.on_key_press_event (cb_window_key_pressed'access);
		main_window.on_configure_event (cb_main_window_configure'access);
		main_window.on_window_state_event (cb_main_window_state_change'access);
		main_window.on_realize (cb_main_window_realize'access);
		main_window.on_activate_default (cb_main_window_activate'access);

		-- Not used:
		-- main_window.on_activate_focus (cb_window_focus'access);

		-- main_window.set_redraw_on_allocate (false);

		gtk_new_hbox (box_h);

		set_up_command_buttons;
		
		-- vertical box for coordinates:
		gtk_new_vbox (box_v1);
		box_v1.set_border_width (10);
		
		-- The left vbox shall not change its width when the 
		-- main window is resized:
		box_h.pack_start (box_v1, expand => false);

		-- Place a separator between the left and right
		-- vertical box:
		separator := gtk_separator_new (ORIENTATION_VERTICAL);
		box_h.pack_start (separator, expand => false);

		-- The right vbox shall expand upon resizing the main window:
		-- box_h.pack_start (box_v2);

		main_window.add (box_h);
	end set_up_main_window;


	
	procedure set_up_coordinates_display is
		use gtk.enums;

		-- The width of the text view shall be wide enough
		-- to fit the greatest numbers:
		pos_field_width_min : constant gint := 80;
	begin
		-- CS To disable focus use
		-- procedure Set_Focus_On_Click
		--    (Widget         : not null access Gtk_Widget_Record;
		--     Focus_On_Click : Boolean);

		-- Create a table, that contains headers, text labels
		-- and text views for the actual coordinates:
		gtk_new (table_coordinates, rows => 11, columns => 2, homogeneous => false);
		-- table.set_col_spacings (50);
		-- table_coordinates.set_border_width (10);

		-- The table shall not expand downward:
		box_v1.pack_start (table_coordinates, expand => false);


		-- POINTER / MOUSE:
		gtk_new (pointer_header, "POINTER");		
		gtk_new (pointer_x_label, "x:"); -- create a text label

		-- The label shall be aligned in the column.
		-- The discussion at:
		-- <https://stackoverflow.com/questions/26345989/gtk-how-to-align-a-label-to-the-left-in-a-table>
		-- gave the solution. See also package gtk.misc for details:
		pointer_x_label.set_alignment (0.0, 0.0);	
		gtk_new (pointer_x_value); -- create a text view vor the value
		-- A minimum width must be set for the text.
		-- Setting the size request is one way. The height is
		-- not affected, therefore the value -1:
		pointer_x_value.set_size_request (pos_field_width_min, -1);
		-- See also discussion at:
		-- <https://stackoverflow.com/questions/24412859/gtk-how-can-the-size-of-a-textview-be-set-manually>
		-- for a way to achieve this using a tag.

		gtk_new (pointer_x_buf); -- create a text buffer
		pointer_x_value.set_justification (JUSTIFY_RIGHT); -- align the value left
		pointer_x_value.set_editable (false); -- the value is not editable
		pointer_x_value.set_cursor_visible (false); -- do not show a cursor

		gtk_new (pointer_y_label, "y:"); -- create a text label
		pointer_y_label.set_alignment (0.0, 0.0);	
		gtk_new (pointer_y_value);
		pointer_y_value.set_size_request (pos_field_width_min, -1);
		gtk_new (pointer_y_buf); -- create a text buffer
		pointer_y_value.set_justification (JUSTIFY_RIGHT); -- align the value left
		pointer_y_value.set_editable (false); -- the value is not editable
		pointer_y_value.set_cursor_visible (false); -- do not show a cursor

		------------------------------------------------------------------------------
		
		-- CURSOR
		gtk_new (cursor_header, "CURSOR");

		gtk_new (cursor_x_label, "x:");
		cursor_x_label.set_alignment (0.0, 0.0);	
		gtk_new (cursor_x_value);
		cursor_x_value.set_size_request (pos_field_width_min, -1);

		gtk_new (cursor_x_buf);
		cursor_x_value.set_justification (JUSTIFY_RIGHT);
		cursor_x_value.set_editable (false);
		cursor_x_value.set_cursor_visible (false);

		gtk_new (cursor_y_label, "y:");
		cursor_y_label.set_alignment (0.0, 0.0);	
		gtk_new (cursor_y_value);
		cursor_y_value.set_size_request (pos_field_width_min, -1);
		gtk_new (cursor_y_buf);
		cursor_y_value.set_justification (JUSTIFY_RIGHT);
		cursor_y_value.set_editable (false);
		cursor_y_value.set_cursor_visible (false);

		------------------------------------------------------------------------------
		-- DISTANCES		
		gtk_new (distances_header, "DISTANCE");
		gtk_new (distances_dx_label, "dx:");
		distances_dx_label.set_alignment (0.0, 0.0);	
		gtk_new (distances_dx_value);
		distances_dx_value.set_size_request (pos_field_width_min, -1);

		gtk_new (distances_dx_buf);
		distances_dx_value.set_justification (JUSTIFY_RIGHT);
		distances_dx_value.set_editable (false);
		distances_dx_value.set_cursor_visible (false);

		
		gtk_new (distances_dy_label, "dy:");
		distances_dy_label.set_alignment (0.0, 0.0);	
		gtk_new (distances_dy_value);
		distances_dy_value.set_size_request (pos_field_width_min, -1);

		gtk_new (distances_dy_buf);
		distances_dy_value.set_justification (JUSTIFY_RIGHT);
		distances_dy_value.set_editable (false);
		distances_dy_value.set_cursor_visible (false);


		gtk_new (distances_absolute_label, "abs:");
		distances_absolute_label.set_alignment (0.0, 0.0);	
		gtk_new (distances_absolute_value);
		distances_absolute_value.set_size_request (pos_field_width_min, -1);

		gtk_new (distances_absolute_buf);
		distances_absolute_value.set_justification (JUSTIFY_RIGHT);
		distances_absolute_value.set_editable (false);
		distances_absolute_value.set_cursor_visible (false);


		gtk_new (distances_angle_label, "angle:");
		distances_angle_label.set_alignment (0.0, 0.0);	
		gtk_new (distances_angle_value);
		distances_angle_value.set_size_request (pos_field_width_min, -1);

		gtk_new (distances_angle_buf);
		distances_angle_value.set_justification (JUSTIFY_RIGHT);
		distances_angle_value.set_editable (false);
		distances_angle_value.set_cursor_visible (false);

		------------------------------------------------------------------------------
		-- GRID
		gtk_new (grid_header, "GRID");
		gtk_new (grid_x_label, "x:");
		grid_x_label.set_alignment (0.0, 0.0);	
		gtk_new (grid_x_value);
		grid_x_value.set_size_request (pos_field_width_min, -1);

		gtk_new (grid_x_buf);
		grid_x_value.set_justification (JUSTIFY_RIGHT);
		grid_x_value.set_editable (false);
		grid_x_value.set_cursor_visible (false);


		gtk_new (grid_y_label, "y:");
		grid_y_label.set_alignment (0.0, 0.0);	
		gtk_new (grid_y_value);
		grid_x_value.set_size_request (pos_field_width_min, -1);

		gtk_new (grid_y_buf);
		grid_y_value.set_justification (JUSTIFY_RIGHT);
		grid_y_value.set_editable (false);
		grid_y_value.set_cursor_visible (false);		

		------------------------------------------------------------------------------
		-- SCALE
		-- gtk_new (scale_header, "SCALE");
		gtk_new (scale_label, "scale:");
		scale_label.set_alignment (0.0, 0.0);	
		gtk_new (scale_value);
		scale_value.set_size_request (pos_field_width_min, -1);

		gtk_new (scale_buf);
		scale_value.set_justification (JUSTIFY_RIGHT);
		scale_value.set_editable (false);
		scale_value.set_cursor_visible (false);


		------------------------------------------------------------------------------


		
		-- Put the items in the table:

		-- MOUSE / POINTER:
		table_coordinates.attach (pointer_header, 
			left_attach	=> 0, right_attach	=> 2, 
			top_attach	=> 0, bottom_attach	=> 1);

		-- x-coordinate:
		table_coordinates.attach (pointer_x_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 1, bottom_attach	=> 2);

		table_coordinates.attach (pointer_x_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 1, bottom_attach	=> 2);

		-- y-coordinate:
		table_coordinates.attach (pointer_y_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 2, bottom_attach	=> 3);
  
		table_coordinates.attach (pointer_y_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 2, bottom_attach	=> 3);


		-- CURSOR:
		table_coordinates.attach (cursor_header, 
			left_attach	=> 0, right_attach	=> 2, 
			top_attach	=> 3, bottom_attach	=> 4);

		-- x-coordinate:
		table_coordinates.attach (cursor_x_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 4, bottom_attach	=> 5);

		table_coordinates.attach (cursor_x_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 4, bottom_attach	=> 5);

		-- y-coordinate:
		table_coordinates.attach (cursor_y_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 5, bottom_attach	=> 6);
  
		table_coordinates.attach (cursor_y_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 5, bottom_attach	=> 6);



		-- DISTANCES:
		table_coordinates.attach (distances_header, 
			left_attach	=> 0, right_attach	=> 2, 
			top_attach	=> 6, bottom_attach	=> 7);

		-- x-coordinate:
		table_coordinates.attach (distances_dx_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 7, bottom_attach	=> 8);

		table_coordinates.attach (distances_dx_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 7, bottom_attach	=> 8);

		-- y-coordinate:
		table_coordinates.attach (distances_dy_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 9, bottom_attach	=> 10);
  
		table_coordinates.attach (distances_dy_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 9, bottom_attach	=> 10);

		-- absolute:
		table_coordinates.attach (distances_absolute_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 10, bottom_attach => 11);
  
		table_coordinates.attach (distances_absolute_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 10, bottom_attach => 11);
		
		-- angle:
		table_coordinates.attach (distances_angle_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 11, bottom_attach => 12);
  
		table_coordinates.attach (distances_angle_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 11, bottom_attach => 12);


		
		-- GRID:
		table_coordinates.attach (grid_header, 
			left_attach	=> 0, right_attach	=> 2, 
			top_attach	=> 12, bottom_attach => 13);

		-- x-axis:
		table_coordinates.attach (grid_x_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 13, bottom_attach => 14);
  
		table_coordinates.attach (grid_x_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 13, bottom_attach => 14);

		-- y-axis:
		table_coordinates.attach (grid_y_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 14, bottom_attach => 15);
  
		table_coordinates.attach (grid_y_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 14, bottom_attach => 15);

		-- scale:
		table_coordinates.attach (scale_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 15, bottom_attach => 16);
  
		table_coordinates.attach (scale_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 15, bottom_attach => 16);

	end set_up_coordinates_display;
	


	procedure backup_visible_area (
		area : in type_area)
	is begin
		last_visible_area := area;
	end backup_visible_area;

	

	function get_ratio (
		area : in type_area)
		return type_scale_factor
	is
		-- The allocation of the scrolled window provides
		-- its width and height:
		a : gtk_allocation;
		
		-- The two scale factors: one based on the width and another
		-- based on the height of the given area:
		sw, sh : type_scale_factor;
	begin
		-- put_line ("get_ratio");

		-- Get the current width and height of the scrolled window:
		swin.get_allocation (a);

		-- Get the ratio of width and height based on the current dimensions
		-- of the scrolled window:
		sw := type_scale_factor (type_distance_model (a.width) / area.width);
		sh := type_scale_factor (type_distance_model (a.height) / area.height);

		-- CS: Alternatively the ratio can be based on the initial dimensions
		-- of the scrolled window. A boolean argument for this function could be
		-- used to switch between current dimensions and initial dimensions:
		-- sw := type_scale_factor (type_distance_model (swin_size_initial.width) / area.width);
		-- sh := type_scale_factor (type_distance_model (swin_size_initial.height) / area.height);
		
		-- put_line ("sw: " & to_string (sw));
		-- put_line ("sh: " & to_string (sh));

		-- The smaller of sw and sh has the final say:
		return type_scale_factor'min (sw, sh);
	end get_ratio;
	
	
	
	procedure cb_swin_size_allocate (
		swin		: access gtk_widget_record'class;
		allocation	: gtk_allocation)
	is 

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
		
		
		-- When the scrolled window is resized, then it expands away from its top left corner
		-- or it shrinks toward its top-left corner. In both cases the bottom of the
		-- window moves down or up. So the bottom of the canvas must follow the bottom
		-- of the scrolled window. This procedure moves the bottom of the canvas by the same
		-- extent as the bottom of the scrolled window:
		procedure move_canvas_bottom is begin
			-- Approach 1:
			-- One way to move the canvas is to change the y-component of the base-offset.
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
		-- This procedure is required when zoom mode MODE_KEEP_CENTER is enabled:
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
		-- with other actions. If the size has not changed, then nothing happens:
		if new_size /= swin_size then
			new_line;
			put_line ("scrolled window size changed");

			-- Opon resizing the scrolled window, the settings of the scrollbars 
			-- (upper, lower and page size) adapt to the size of the scrolled window. 
			-- But we do NOT want this behaviour. Instead we restore the settings
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
	


	
-- SCROLLBARS:

	
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
		event_handled : boolean := false;
	begin
		-- put_line ("cb_scrollbar_h_released");
		backup_scrollbar_settings;

		backup_visible_area (get_visible_area (canvas));
		return event_handled;
	end cb_scrollbar_h_released;


	procedure backup_scrollbar_settings is begin
		--put_line ("backup_scrollbar_settings");
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


	

	procedure set_up_swin_and_scrollbars is	begin
		put_line ("set_up_swin_and_scrollbars");
		
		-- Create a scrolled window:
		swin := gtk_scrolled_window_new (hadjustment => null, vadjustment => null);

		-- Set the minimum size of the scrolled window and
		-- the global swin_size variable.
		-- There are two ways to do that:
		--
		-- 1. Basing on the global bounding-box which has been calculated
		--    by parsing the model database. This causes the scrolled window
		--    to adapt on startup to the model.
		--    IMPORTANT: The height must be greater than the sum
		--    of the height of all other widgets in the main window !
		--    Otherwise the canvas may freeze and stop emitting signals:
		--
		-- swin.set_size_request (
		-- 	gint (bounding_box.width),
		-- 	gint (bounding_box.height)); -- Mind a minimal height ! See above comment.
		-- 
		-- swin_size := (
		-- 	width	=> positive (bounding_box.width),
		-- 	height	=> positive (bounding_box.height));

		
		-- 2. A static startup-configuration based on a certain 
		--    minimal width and height. This ensures that the scrolled
		--    window has a predictable and well defined size.
		--    This is to be prefered over approach 1 (see above):
		swin.set_size_request (
			gint (swin_size_initial.width),
			gint (swin_size_initial.height));
  
		swin_size := (
			width	=> swin_size_initial.width,
			height	=> swin_size_initial.height);


		
		-- CS show window size

		put_line ("scrolled window zoom mode: " 
			& type_scrolled_window_zoom_mode'image (zoom_mode));

		
		-- swin.set_border_width (10);
		-- swin.set_redraw_on_allocate (false);

		
		scrollbar_h_adj := swin.get_hadjustment;
		scrollbar_v_adj := swin.get_vadjustment;

		
		-- connect signals:
		swin.on_size_allocate (cb_swin_size_allocate'access);
		-- After executing procedure cb_swin_size_allocate
		-- the canvas is refreshed (similar to refresh (canvas)) automatically..

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


		-- CS: Attempt to disable auto-scrolling of scrollbars
		-- when the canvas get the focus:
		-- set_focus_hadjustment (
		-- 	container	=> swin,
		-- 	adjustment	=> scrollbar_h_adj);

		-- scrollbar_h.set_can_focus (false);
		-- swin.grab_focus;

		-- swin.set_propagate_natural_height (true);
		
		update_cursor_coordinates;
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

	
	
	procedure set_initial_scrollbar_settings is
		debug : boolean := false;
		-- debug : boolean := true;
	begin
		put_line ("set initial scrollbar settings");
		
		scrollbar_v_init.upper := - F.y;			
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
		
		scrollbar_h_init.lower := F.x;
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

	
		--------------------------------------------------------------------------------
		-- CS: This code is experimental in order to make the canvas
		-- dimensions adjust DYNAMICALLY to the scrollbar limits. So far this
		-- was not successful because the canvas size can not be changed
		-- for some unknown reason after initialization:
		
-- 		declare
-- 			w, h : gint;
-- 			a : gtk_allocation;
-- 		begin
-- 			w := gint (scrollbar_h_init.lower + scrollbar_h_init.upper);
-- 			h := gint (scrollbar_v_init.lower + scrollbar_v_init.upper);
-- 
-- 			canvas.get_allocation (a);
-- 			a.width := w;
-- 			a.height := h;
-- 			-- canvas.set_allocation (a);
-- 			-- canvas.size_allocate (a);
-- 			-- canvas.set_size_request (w, h);
-- 			
-- 			if debug then
-- 				show_canvas_size;
-- 				-- put_line ("x/y : " & gint'image (a.x) & "/" & gint'image (a.y));
-- 			end if;
-- 		end;
		--------------------------------------------------------------------------------

		
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

		-- show_adjustments_h;
		-- show_adjustments_v;
		
		backup_scrollbar_settings;
		
	end set_initial_scrollbar_settings;
	

	
-- CANVAS:
	
	procedure refresh (
		canvas	: access gtk_widget_record'class)
	is
		drawing_area : constant gtk_drawing_area := gtk_drawing_area (canvas);
	begin
		-- put_line ("refresh " & image (clock)); 
		drawing_area.queue_draw;
	end refresh;


	procedure cb_canvas_size_allocate (
		canvas		: access gtk_widget_record'class;
		allocation	: gtk_allocation)
	is begin
		null;
		-- new_line;
		-- put_line ("cb_canvas_size_allocate");

		-- put_line ("cb_canvas_size_allocate. (x/y/w/h): " & gint'image (allocation.x) 
		-- 	& " /" & gint'image (allocation.y)
		-- 	& " /" & gint'image (allocation.width)
		-- 	& " /" & gint'image (allocation.height));
  
	end cb_canvas_size_allocate;


	procedure compute_canvas_size is
		debug : boolean := true;

		-- The maximal base-offset:
		F_max : type_vector_gdouble;
		
		-- The maximum scale factor:
		S_max : constant gdouble := gdouble (type_scale_factor'last);

		-- The maximum width and height of the bounding-box:
		Bw : constant gdouble := gdouble (bounding_box_width_max);
		Bh : constant gdouble := gdouble (bounding_box_height_max);
	begin
		if debug then
			put_line ("compute_canvas_size");
			put_line (" S_max : " & gdouble'image (S_max));
			put_line (" Bw_max: " & gdouble'image (Bw));
			put_line (" Bh_max: " & gdouble'image (Bh));
		end if;

		-- compute the maximal base-offset:
		F_max.x :=   Bw * (S_max - 1.0);
		F_max.y := - Bh * S_max;

		if debug then
			put_line (" F_max : " & to_string (F_max));
		end if;

		-- compute the canvas width and height:
		canvas_size.width  := positive (  F_max.x + Bw * S_max);
		canvas_size.height := positive (- F_max.y + Bh * (S_max - 1.0));

		if debug then
			put_line (" Cw    : " & positive'image (canvas_size.width));
			put_line (" Ch    : " & positive'image (canvas_size.height));
		end if;
	end compute_canvas_size;

	

	procedure show_canvas_size is 
		a : gtk_allocation;
		width, height : gint;
	begin
		canvas.get_allocation (a);
		put_line ("canvas size allocated (w/h):" 
			& gint'image (a.width) & " /" & gint'image (a.height));
		
		canvas.get_size_request (width, height);
		put_line ("canvas size minimum   (w/h):" 
			& gint'image (width) & " /" & gint'image (height));
	end show_canvas_size;

	
	
	procedure set_up_canvas is
	begin
		put_line ("set_up_canvas");
		
		-- Set up the drawing area:
		gtk_new (canvas);

		-- Connect signals:

		-- Not used:
		-- canvas.on_size_allocate (cb_canvas_size_allocate'access);
		-- canvas.set_redraw_on_allocate (false);
		
		-- Set the size (width and height) of the canvas:
		canvas.set_size_request (gint (canvas_size.width), gint (canvas_size.height));
		
		show_canvas_size;

		
		-- Connect further signals:
		canvas.on_draw (cb_draw_objects'access);
		-- NOTE: No context is declared here, because the canvas widget
		-- passes its own context to the callback procedure cb_draw.

		
		-- Make the canvas responding to mouse button clicks:
		canvas.add_events (gdk.event.button_press_mask);
		canvas.on_button_press_event (cb_canvas_button_pressed'access);

		canvas.add_events (gdk.event.button_release_mask);
		canvas.on_button_release_event (cb_canvas_button_released'access);
		
		-- Make the canvas responding to mouse movement:
		canvas.add_events (gdk.event.pointer_motion_mask);
		canvas.on_motion_notify_event (cb_mouse_moved'access);

		-- Make the canvas responding to the mouse wheel:
		canvas.add_events (gdk.event.scroll_mask);
		canvas.on_scroll_event (cb_mouse_wheel_rolled'access);
		
		-- Make the canvas responding to the keyboard:
		canvas.set_can_focus (true);
		canvas.add_events (key_press_mask);
		canvas.on_key_press_event (cb_canvas_key_pressed'access);

		-- Add the canvas as a child to the scrolled window:
		put_line ("add canvas to scrolled window");
		swin.add (canvas); 

		-- Insert the scrolled window in box_h:
		put_line ("add scrolled window to box_h");
		box_h.pack_start (swin);

	end set_up_canvas;


	procedure shift_canvas (
		direction	: type_direction;
		distance	: type_distance_model)
	is
		-- Convert the given model distance to 
		-- a canvas distance:
		d : constant gdouble := gdouble (distance) * gdouble (S);

		-- Scratch values for upper limit, lower limit and value
		-- of scrollbars:
		u, l, v : gdouble;
	begin
		case direction is
			when DIR_RIGHT =>
				-- Get the maximal allowed value for the
				-- horizontal scrollbar:
				u := scrollbar_h_adj.get_upper;

				-- Compute the required scrollbar position:
				v := scrollbar_h_adj.get_value + d;

				-- Clip the required position if necesary,
				-- then apply it to the scrollbar:
				clip_max (v, u);
				scrollbar_h_adj.set_value (v);

				
			when DIR_LEFT =>
				-- Get the minimal allowed value for the
				-- horizontal scrollbar:
				l := scrollbar_h_adj.get_lower;

				-- Compute the required scrollbar position:
				v := scrollbar_h_adj.get_value - d;

				-- Clip the required position if necesary,
				-- then apply it to the scrollbar:
				clip_min (v, l);
				scrollbar_h_adj.set_value (v);

				
			when DIR_UP =>
				-- Get the minimal allowed value for the
				-- vertical scrollbar:
				l := scrollbar_v_adj.get_lower;
				
				-- Compute the required scrollbar position:
				v := scrollbar_v_adj.get_value - d;

				-- Clip the required position if necesary,
				-- then apply it to the scrollbar:
				clip_min (v, l);
				scrollbar_v_adj.set_value (v);

				
			when DIR_DOWN =>
				-- Get the maximal allowed value for the
				-- vertical scrollbar:
				u := scrollbar_v_adj.get_upper;

				-- Compute the required scrollbar position:
				v := scrollbar_v_adj.get_value + d;

				-- Clip the required position if necesary,
				-- then apply it to the scrollbar:
				clip_max (v, u);
				scrollbar_v_adj.set_value (v);
				
		end case;

		backup_scrollbar_settings;
	end shift_canvas;

	

	

	function get_visible_area (
		canvas	: access gtk_widget_record'class)
		return type_area
	is
		result : type_area;

		-- The allocation of the scrolled window:
		W : gtk_allocation;
		
		h_start, h_length, h_end : gdouble;
		v_start, v_length, v_end : gdouble;

		-- The four corners of the visible area:
		BL, BR, TL, TR : type_vector_model;
	begin
		-- Inquire the allocation of the scrolled window
		-- inside the main window:
		get_allocation (swin, W);

		
		-- X-AXIS:
		
		-- The visible area along the x-axis starts at the
		-- position of the horizontal scrollbar:
		h_start  := scrollbar_h_adj.get_value;

		-- The visible area along the x-axis is as wide as
		-- the scrolled window:
		h_length := gdouble (W.width);

		-- The visible area ends here:
		h_end    := h_start + h_length;


		-- Y-AXIS:
		
		-- The visible area along the y-axis starts at the
		-- position of the vertical scrollbar:
		v_start := scrollbar_v_adj.get_value;

		-- The visible area along the y-axis is as high as
		-- the scrolled window:
		v_length := gdouble (W.height);

		-- The visible area along the y-axis ends here:
		v_end := v_start + v_length;

		
		-- Compute the corners of the visible area.
		-- The corners are real model coordinates:
		BL := to_model ((h_start, v_end),   S, true);
		BR := to_model ((h_end, v_end),     S, true);
		TL := to_model ((h_start, v_start), S, true);
		TR := to_model ((h_end, v_start),   S, true);

		-- put_line ("BL " & to_string (BL));
		-- put_line ("BR " & to_string (BR));
		-- put_line ("TR " & to_string (TR));
		-- put_line ("TL " & to_string (TL));

		-- The position of the visible area is the lower left 
		-- corner:
		result.position := BL;
		
		-- Compute the width and the height of the
		-- visible area:
		result.width := TR.x - TL.x;
		result.height := TL.y - BL.y;

		-- CS: more effective ?
		-- result.width    := type_distance_model (h_length) * type_distance_model (S);
		-- result.height   := type_distance_model (v_length) * type_distance_model (S);

		-- put_line ("visible area " & to_string (result));
		return result;
	end get_visible_area;



	procedure center_to_visible_area (
		area : in type_area)
	is
		-- debug : boolean := true;
		debug : boolean := false;
		
		-- The offset required to "move" all objects into
		-- the center of the visible area:
		dx, dy : type_distance_model;
		
		-- Get the currently visible model area:
		v : constant type_area := get_visible_area (canvas);

		w1 : constant type_distance_model := v.width;
		w2 : constant type_distance_model := area.width;

		h1 : constant type_distance_model := v.height;
		h2 : constant type_distance_model := area.height;

		a, b : type_distance_model;

		x0 : constant type_distance_model := area.position.x;
		y0 : constant type_distance_model := area.position.y;
		
		x1 : constant type_distance_model := v.position.x;
		y1 : constant type_distance_model := v.position.y;

		-- The given area will end up at this target position:
		x2, y2 : type_distance_model;
	begin
		if debug then
			put_line ("given   " & to_string (area));
			put_line ("visible " & to_string (v));
		end if;
		
		a := (w1 - w2) * 0.5;
		x2 := x1 + a;
		dx := x2 - x0;

		b := (h1 - h2) * 0.5;
		y2 := y1 + b;
		dy := y2 - y0;

		if debug then
			put_line ("dx:" & to_string (dx));
			put_line ("dy:" & to_string (dy));
		end if;

		-- Convert the model offset (dx;dy) to a canvas offset
		-- and apply it to the global translate-offset.
		-- Regarding y: T is in the canvas system (CS2)
		-- where the y-axis goes downward. So we must multiply by -1:
		T.x :=   gdouble (dx) * gdouble (S);
		T.y := - gdouble (dy) * gdouble (S);
		if debug then
			put_line ("T: " & to_string (T));
		end if;

	end center_to_visible_area;


	
	procedure zoom_on_cursor (
		direction : in type_zoom_direction)
	is
		S1 : constant type_scale_factor := S;

		-- The corners of the bounding-box on the canvas before 
		-- and after zooming:
		C1, C2 : type_bounding_box_corners;
	begin
		put_line ("zoom_on_cursor " & type_zoom_direction'image (direction));

		C1 := get_bounding_box_corners;

		case direction is
			when ZOOM_IN =>
				increase_scale;
				put_line (" zoom in");
				
			when ZOOM_OUT => 
				decrease_scale;
				put_line (" zoom out");
				
			when others => null;
		end case;

		update_scale_display;
		
		-- put_line (" S" & to_string (S));

		-- After changing the scale-factor, the translate-offset must
		-- be calculated anew. When the actual drawing takes 
		-- place (see function cb_draw_objects)
		-- then the drawing will be dragged back by the translate-offset
		-- so that the operator gets the impression of a zoom-into or zoom-out effect.
		-- Without applying a translate-offset the drawing would be appearing as 
		-- expanding to the upper-right (on zoom-in) or shrinking toward the lower-left:
		set_translation_for_zoom (S1, S, cursor.position);

		C2 := get_bounding_box_corners;
		update_scrollbar_limits (C1, C2);

		-- show_adjustments_v;

		backup_visible_area (get_visible_area (canvas));
		
		-- schedule a redraw:
		refresh (canvas);		
	end zoom_on_cursor;

	

	procedure zoom_to_fit (
		area : in type_area)
	is
		debug : boolean := false;
	begin
		put_line ("zoom_to_fit");

		-- Calculate the scale-factor that is required to
		-- fit the given area into the scrolled window:
		S := get_ratio (area);
		
		if debug then
			put_line (" S: " & type_scale_factor'image (S));
		end if;

		update_scale_display;
		-----------------------------------------------------

		-- Calculate the translate-offset that is required to
		-- center the given area on the visible area:
		center_to_visible_area (area);

		if debug then
			show_adjustments_h;
			show_adjustments_v;
		end if;

		--backup_scrollbar_settings;
	end zoom_to_fit;


	procedure zoom_to_fit_all is
		-- debug : boolean := true;
		debug : boolean := false;
	begin
		-- put_line ("zoom_to_fit");

		-- Reset the translate-offset:
		T := (0.0, 0.0);
		
		-- Compute the new bounding-box. Update global
		-- variable bounding_box:
		compute_bounding_box;

		-- Compute the new base-offset. Update global variable F:
		set_base_offset;

		-- Since the bounding_box has changed, the scrollbars
		-- must be reinitialized:
		set_initial_scrollbar_settings;

		-- Calculate the scale-factor that is required to
		-- fit all objects into the scrolled window:
		S := get_ratio (bounding_box);

		
		
		if debug then
			put_line (" S: " & type_scale_factor'image (S));
		end if;

		update_scale_display;


		-- Calculate the translate-offset that is required to
		-- "move" all objects to the center of the visible area:
		center_to_visible_area (bounding_box);

		backup_visible_area (bounding_box);
		
		-- Schedule a redraw of the canvas:
		refresh (canvas);
	end zoom_to_fit_all;
	

	
	
	function cb_canvas_button_pressed (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean
	is
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
		-- <https://stackoverflow.com/questions/26693042/gtkscrolledwindow-disable-scroll-to-focused-child>
		-- or
		-- <https://discourse.gnome.org/t/disable-auto-scrolling-in-gtkscrolledwindow-when-grab-focus-in-children/13058>
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
				zoom_area.area.width  := abs (zoom_area.k2.x - zoom_area.k1.x);
				zoom_area.area.height := abs (zoom_area.k2.y - zoom_area.k1.y);

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


	
	
	
	function cb_mouse_moved (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_motion)
		return boolean
	is
		use glib;
		event_handled : boolean := true;

		cp : constant type_vector_gdouble := (event.x, event.y);

		-- Get the real model coordinates:
		mp : constant type_vector_model := to_model (cp, S, true);
	begin
		-- put_line ("cb_mouse_moved");

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
	end cb_mouse_moved;



	procedure move_cursor (
		destination : type_vector_model)
	is
	begin
		cursor.position := destination;
		update_cursor_coordinates;
		update_distances_display;
		
		-- Output the cursor position on the terminal:
		put_line ("position " & to_string (cursor.position));
	end move_cursor;

	
	procedure move_cursor (
		direction : type_direction)
	is begin
		-- Move the cursor by the grid spacing into the given direction:
		put_line ("move cursor " & type_direction'image (direction));
		
		case direction is
			when DIR_RIGHT =>
				cursor.position.x := cursor.position.x + grid.spacing.x;

			when DIR_LEFT =>
				cursor.position.x := cursor.position.x - grid.spacing.x;

			when DIR_UP =>
				cursor.position.y := cursor.position.y + grid.spacing.y;

			when DIR_DOWN =>
				cursor.position.y := cursor.position.y - grid.spacing.y;
		end case;


		-- If the cursor is outside the visible area, then the
		-- canvas must be shifted with the cursor:
		if not in_area (cursor.position, visible_area) then
			put_line ("cursor not in visible area");

			case direction is
				when DIR_RIGHT =>
					-- If the cursor is right of the visible area,
					-- then shift the canvas to the right:
					if cursor.position.x > visible_area.position.x + visible_area.width then
						shift_canvas (direction, grid.spacing.x);
					end if;
					
				when DIR_LEFT =>
					-- If the cursor is left of the visible area,
					-- then shift the canvas to the left:
					if cursor.position.x < visible_area.position.x then
						shift_canvas (direction, grid.spacing.x);
					end if;
					
				when DIR_UP =>
					-- If the cursor is above of the visible area,
					-- then shift the canvas up:
					if cursor.position.y > visible_area.position.y + visible_area.height then
						shift_canvas (direction, grid.spacing.y);
					end if;

				when DIR_DOWN =>
					-- If the cursor is below of the visible area,
					-- then shift the canvas down:
					if cursor.position.y < visible_area.position.y then
						shift_canvas (direction, grid.spacing.y);
					end if;

			end case;

		end if;
			
		refresh (canvas);		
		
		update_cursor_coordinates;
		update_distances_display;

		-- Output the cursor position on the terminal:
		put_line ("cursor at " & to_string (cursor.position));

		backup_visible_area (get_visible_area (canvas));
	end move_cursor;


	
	
	function cb_canvas_key_pressed (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_key)
		return boolean
	is
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
		use glib;		
		use gdk.types;
		use gtk.accel_group;
		event_handled : boolean := true;

		accel_mask : constant gdk_modifier_type := get_default_mod_mask;

		-- The direction at which the operator is turning the wheel:
		wheel_direction : constant gdk_scroll_direction := event.direction;


		procedure zoom is
			-- The given point on the canvas where the operator is zooming in or out:
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
					put_line (" zoom in");
					update_scale_display;
					
				when SCROLL_DOWN => 
					decrease_scale;
					put_line (" zoom out");
					update_scale_display;
					
				when others => null;
			end case;

			-- put_line (" S" & to_string (S));
			
			-- After changing the scale-factor, the translate-offset must
			-- be calculated anew. When the actual drawing takes 
			-- place (see function cb_draw_objects)
			-- then the drawing will be dragged back by the translate-offset
			-- so that the operator gets the impression of a zoom-into or zoom-out effect.
			-- Without applying a translate-offset the drawing would be appearing as 
			-- expanding to the upper-right (on zoom-in) or shrinking toward the lower-left:
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
			v1, dv, v2 : gdouble;

			procedure set_delta is begin
				null;
				-- CS: This is emperical for the time being.
				-- Rework required.
				dv := 10.0 * gdouble (S);
			end set_delta;
			
		begin
			put_line (type_scroll_direction'image (direction));

			case direction is
				when SCROLL_UP =>
					v1 := scrollbar_v_adj.get_value;
					set_delta;
					v2 := v1 + dv;
					scrollbar_v_adj.set_value (v2);
					
				when SCROLL_DOWN =>
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
		-- new_line;
		put_line ("mouse_wheel_rolled");
		-- put_line (" direction " & gdk_scroll_direction'image (direction));


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



	
	
	procedure draw_line (
		context	: in cairo_context; -- CS make context global ?
		line	: in type_line;
		pos		: in type_vector_model)
	is
		-- CS: Optimization required. Compiler options ?
		
		-- Make a copy of the given line:
		l : type_line := line;

		-- When the line is drawn, we need canvas points
		-- for start and end:
		c1, c2 : type_vector_gdouble; -- start and end of the line

		-- The bounding-box of the line. It is required
		-- for the area and size check:
		b : type_area;
		
	begin
		-- Move the line to the given position:
		move_line (l, pos);
		
		-- Get the bounding-box of line:
		b := get_bounding_box (l);
		-- put_line ("b" & to_string (b));
		
		-- Do the area check. If the bounding-box of the line
		-- is inside the visible area then draw the line. Otherwise
		-- nothing will be drawn:
		if areas_overlap (visible_area, b) and then

			-- Do the size check. If the bounding-box is greater
			-- (either in width or heigth) than the visiblity threshold
			-- then draw the line. Otherwise nothing will be drawn:
			above_visibility_threshold (b) then

			--put_line ("draw line");

			set_line_width (context, to_distance (line.w));

			c1 := to_canvas (l.s, S, real => true);
			c2 := to_canvas (l.e, S, real => true);
			move_to (context, c1.x, c1.y);
			line_to (context, c2.x, c2.y);
			stroke (context);
		end if;
	end draw_line;

	
	procedure draw_circle (
		context	: in cairo_context; -- CS make context global ?
		circle	: in type_circle;
		pos		: in type_vector_model) -- the position of the complex object
	is
		-- CS: Optimization required. Compiler options ?
	begin
		-- CS 
		null;
	end draw_circle;

	
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
		-- 1. Define the begin and end of the visible area in x and y direction.
		-- 2. Find the first column that comes after the begin of 
		--    the visible area (in x direction).
		-- 3. Find the last column that comes before the end of the 
		--    visible area (in x direction).
		-- 4. Find the first row that comes after the begin of the 
		--    visible area (in y direction).
		-- 5. Find the last row that comes before the end of the 
		--    visible area (in y direction).
		-- 6. Draw the grid as dots or lines, depending on the user specified settings.
		procedure draw_grid is
			type type_float_grid is new float; -- CS refinement required

			-- X-AXIS:

			-- The first and the last column:
			x1, x2 : type_distance_model;

			-- The start and the end of the visible area:
			ax1 : constant type_float_grid := type_float_grid (visible_area.position.x);
			ax2 : constant type_float_grid := ax1 + type_float_grid (visible_area.width);

			-- The grid spacing:
			gx : constant type_float_grid := type_float_grid (grid.spacing.x);

			
			-- Y-AXIS:

			-- The first and the last row:
			y1, y2 : type_distance_model;

			-- The start and the end of the visible area:
			ay1 : constant type_float_grid := type_float_grid (visible_area.position.y);
			ay2 : constant type_float_grid := ay1 + type_float_grid (visible_area.height);

			-- The grid spacing:
			gy : constant type_float_grid := type_float_grid (grid.spacing.y);

			c : type_float_grid;

			-- debug : boolean := false;

			
			procedure compute_first_and_last_column is
			begin
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


			procedure compute_first_and_last_row is
			begin
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
			-- 1. Assemble from the first row and the first colum a real model point MP.
			-- 2. Advance PM from row to row and column to column in a matrix like order.
			-- 3. Draw a very small circle, which will appear like a dot,
			--    (or alternatively a crosshair) at PM.
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
						arc (context, CP.x, CP.y, 
							radius => grid_radius_dots, angle1 => 0.0, angle2 => 6.3);
						
						stroke (context);

						-- CS: As an alternative a small crosshair could
						-- be drawn at CP. This could be more efficient than a circle.
						
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

				-- All vertical lines start at the bottom of the visible area:
				MP1 := (x1, ay1f);

				-- All vertical lines end at the top of the visible area:
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

				-- All horizontal lines start at the left edge of the visible area:
				MP1 := (ax1f, y1);

				-- All horizontal lines end at the right edge of the visible area:
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
			cp : type_vector_gdouble := to_canvas (cursor.position, S, true);

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

		

		-- Draws all model objects. Parses the model database
		-- and draws objects one by one:
		procedure draw_objects is
			use pac_lines;
			use pac_circles;
			use pac_objects;
			
			c : type_vector_gdouble;

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
					--put_line ("query_circle");
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
		
		draw_objects;
		
		
		return event_handled;
	end cb_draw_objects;

	
end callbacks;

