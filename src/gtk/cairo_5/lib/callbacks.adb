------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                    CALLBACK FUNCTIONS AND PROCEDURES                     --
--                                                                          --
--                               B o d y                                    --
--                                                                          --
-- Copyright (C) 2023                                                       --
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
with ada.text_io;				use ada.text_io;
with ada.calendar;				use ada.calendar;
with ada.calendar.formatting;	use ada.calendar.formatting;

with gtk.main;					use gtk.main;



package body callbacks is

	procedure update_cursor_coordinates is begin
		gtk_entry (CC.position_x.get_child).set_text (to_string (cursor.position.x));
		gtk_entry (CC.position_y.get_child).set_text (to_string (cursor.position.y));
	end update_cursor_coordinates;


	
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


	
		
	procedure cb_main_window_size_allocate (
		window		: access gtk_widget_record'class;
		allocation	: gtk_allocation)
	is 
	begin -- cb_main_window_size_allocate
		null;
		
		-- put_line ("cb_main_window_size_allocate " & image (clock)); 

		-- put_line ("cb_main_window_size_allocate. (x/y/w/h): " 
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
		-- restore_scrollbar_settings;
		return result;
	end cb_main_window_state_change;


	procedure cb_main_window_activate (
		window		: access gtk_window_record'class)
	is begin
		null;
		-- put_line ("cb_main_window_activate " & image (clock)); 
	end cb_main_window_activate;

	
	procedure set_up_main_window is
	begin
		main_window := gtk_window_new (WINDOW_TOPLEVEL);
		main_window.set_title ("Demo Canvas");
		main_window.set_border_width (10);

		-- CS: Set the minimum size of the main window ?
		-- CS show main window size
		
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

	
	procedure set_up_coordinates_display is
		use gtk.enums;
	begin
		-- CS To disable focus use
		-- procedure Set_Focus_On_Click
		--    (Widget         : not null access Gtk_Widget_Record;
		--     Focus_On_Click : Boolean);

		
		gtk_new_hbox (h_box_1);
		h_box_1.set_spacing (10);
		main_window.add (h_box_1);

		gtk_new_vbox (v_box_1);
		h_box_1.pack_start (v_box_1, expand => false);

		separator_1 := gtk_separator_new (ORIENTATION_VERTICAL);
		h_box_1.pack_start (separator_1, expand => false);

		-- separator_2 := gtk_separator_new (ORIENTATION_VERTICAL);
		-- h_box_1.pack_start (separator_2, expand => false);

		
		-- POINTER / MOUSE
		gtk_new_vbox (PC.main_box);
		v_box_1.pack_start (PC.main_box, expand => false);

		gtk_new (PC.title);
		PC.title.set_text ("POINTER");
		PC.main_box.pack_start (PC.title, expand => false);

		-- x-axis:
		gtk_new_hbox (PC.box_x);
		PC.box_x.set_spacing (5);
		PC.main_box.pack_start (PC.box_x, expand => false);
		
		gtk_new (PC.label_x);
		PC.label_x.set_text ("X");
		PC.box_x.pack_start (PC.label_x, expand => false);
		
		gtk_new_with_entry (PC.position_x);
		PC.box_x.pack_start (PC.position_x, expand => false);

		-- y-axis:
		gtk_new_hbox (PC.box_y);
		PC.box_y.set_spacing (5);
		PC.main_box.pack_start (PC.box_y, expand => false);
		
		gtk_new (PC.label_y);
		PC.label_y.set_text ("Y");
		PC.box_y.pack_start (PC.label_y, expand => false);
		
		gtk_new_with_entry (PC.position_y);
		PC.box_y.pack_start (PC.position_y, expand => false);


		-- CURSOR
		gtk_new_vbox (CC.main_box);
		v_box_1.pack_start (CC.main_box, expand => false);
		
		gtk_new (CC.title);
		CC.title.set_text ("CURSOR");
		CC.main_box.pack_start (CC.title, expand => false);

		-- x-axis:
		gtk_new_hbox (CC.box_x);
		CC.box_x.set_spacing (5);
		CC.main_box.pack_start (CC.box_x, expand => false);
		
		gtk_new (CC.label_x);
		CC.label_x.set_text ("X");
		CC.box_x.pack_start (CC.label_x, expand => false);
		
		gtk_new_with_entry (CC.position_x);
		CC.box_x.pack_start (CC.position_x, expand => false);

		-- y-axis:
		gtk_new_hbox (CC.box_y);
		CC.box_y.set_spacing (5);
		CC.main_box.pack_start (CC.box_y, expand => false);
		
		gtk_new (CC.label_y);
		CC.label_y.set_text ("Y");
		CC.box_y.pack_start (CC.label_y, expand => false);
		
		gtk_new_with_entry (CC.position_y);
		CC.box_y.pack_start (CC.position_y, expand => false);
		
	end set_up_coordinates_display;
	

	procedure cb_scrolled_window_size_allocate (
		window		: access gtk_widget_record'class;
		allocation	: gtk_allocation)
	is 
		-- The current scale factor:
		S1 : constant type_scale_factor := scale_factor;

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

		
		-- NOTE: At the end of this procedure, a redraw is called automatically.
		-- No need for an extra call of "refresh (canvas)".


		-- For debugging. Outputs the dimensions and size
		-- changes of the main window:
		procedure show_size is begin
			put_line (" size old (w/h): " 
				& positive'image (scrolled_window_size.width)
				& " /" & positive'image (scrolled_window_size.height));
			
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
		-- of the main window. This procedure moves the bottom of the canvas by the same
		-- extent as the bottom of the scrolled window:
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
				canvas_allocation.y := canvas_allocation.y + (new_size.height - scrolled_window_size.height);
				-- put_line ("canvas_allocation.y  : " & positive'image (canvas_allocation.y));

				get_allocation (canvas, L);
				L.y := gint (canvas_allocation.y);
				canvas.size_allocate (L);
			end;

		end move_canvas_bottom;
		

		-- This procedure should move the canvas so that the center
		-- remains in the center of the scrolled window. 
		-- Related to MODE_ZOOM_CENTER.
		-- This is a construction site (CS). No suitable solution found yet:
		procedure move_center_and_zoom is 
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

			S2W := to_scale_factor (scrolled_window_size.width, new_size.width);
			-- put_line ("S2W:" & to_string (S2W));

			S2H := to_scale_factor (scrolled_window_size.height, new_size.height);
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

		
	begin -- cb_scrolled_window_size_allocate
		
		-- put_line ("cb_scrolled_window_size_allocate " & image (clock)); 
		-- put_line ("cb_scrolled_window_size_allocate. (x/y/w/h): " 
		-- 	& gint'image (allocation.x) 
		-- 	& " /" & gint'image (allocation.y)
		-- 	& " /" & gint'image (allocation.width)
		-- 	& " /" & gint'image (allocation.height));

		-- This procedure is called on many occasions. We are interested
		-- only in cases where the size changes.
		-- So we watch for changes of width and height only:
		
		-- Compare the new size with the old size. The global variable 
		-- scrolled_window_size provides the size of the window BEFORE this
		-- procedure has been called. If the size has changed, then we start 
		-- zooming in or out. The zoom center is ths canvas point in the 
		-- center of the visible area:
		if new_size /= scrolled_window_size then
			new_line;
			put_line ("scrolled window size changed");

			-- Opon resizing the scrolled window, the settings of the scrollbars 
			-- (upper, lower and page size) adapt to the size of the canvas. 
			-- But we do NOT want this behaviour. Instead we restore the settings
			-- as they where BEFORE this procedure has been called:
			restore_scrollbar_settings;
			-- show_adjustments_h;
			-- show_adjustments_v;
			
			-- Compute the change of width and height:
			dW := gdouble (new_size.width - scrolled_window_size.width);
			dH := gdouble (new_size.height - scrolled_window_size.height);

			-- for debugging:
			show_size;

			-- Move the canvas so that its bottom follows
			-- the bottom of the scrolled window:
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

			
			-- Adjust scrollbars:
			backup_scrollbar_settings;

			-- Update the scrolled_window_size which is required
			-- for the next time this procedure is called:
			scrolled_window_size := new_size;

		end if;
	end cb_scrolled_window_size_allocate;
	


	
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
		backup_scrollbar_settings;
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

		-- Set the minimum size of the main window basing on the 
		-- bounding-box:
		swin.set_size_request (
			gint (bounding_box.width),
			gint (bounding_box.height));

		-- Set the global scrolled_window_size variable:
		scrolled_window_size := (
			width	=> positive (bounding_box.width),
			height	=> positive (bounding_box.height));

		-- CS show window size

		put_line ("scrolled window zoom mode: " 
			& type_scrolled_window_zoom_mode'image (zoom_mode));

		
		-- swin.set_border_width (10);
		-- swin.set_redraw_on_allocate (false);

		
		scrollbar_h_adj := swin.get_hadjustment;
		scrollbar_v_adj := swin.get_vadjustment;

		
		-- connect signals:
		swin.on_size_allocate (cb_scrolled_window_size_allocate'access);

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

		scrollbar_h.set_can_focus (false);
		
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

		backup_scrollbar_settings;
	end apply_initial_scrollbar_settings;
	

	

	
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
		canvas.on_button_press_event (cb_button_pressed_canvas'access);

		-- Make the canvas responding to mouse movement:
		canvas.add_events (gdk.event.pointer_motion_mask);
		canvas.on_motion_notify_event (cb_mouse_moved'access);

		-- Make the canvas responding to the mouse wheel:
		canvas.add_events (gdk.event.scroll_mask);
		canvas.on_scroll_event (cb_mouse_wheel_rolled'access);
		
		-- Make the canvas responding to the keyboard:
		canvas.set_can_focus (true);
		canvas.add_events (key_press_mask);
		canvas.on_key_press_event (cb_key_pressed_canvas'access);

	end set_up_canvas;


	procedure shift_canvas (
		direction	: type_direction;
		distance	: type_distance_model)
	is
		-- Convert the given model distance to 
		-- a canvas distance:
		d : constant gdouble := gdouble (distance) * gdouble (scale_factor);

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

	

-- 	function model_point_visible (
-- 		point 		: in type_point_model)
-- 		return type_model_point_visible
-- 	is
-- 		result : type_model_point_visible;
-- 		C : type_point_canvas;
-- 	begin
-- 		-- put_line ("M " & to_string (point));
-- 		
-- 		C := to_canvas (
-- 			point	=> point,
-- 			scale	=> scale_factor,
-- 			real	=> true);
-- 
-- 		-- put_line ("C " & to_string (C));
-- 
-- 		-- X-axis:
-- 		-- The visible area ranges from the current position
-- 		-- of the horizontal scrollbar (value) to the end of the
-- 		-- scrollbar (value + page_size). If C.x lies in that range,
-- 		-- then the corresponding flag in the return will be set.
-- 		if C.x >= scrollbar_h_adj.get_value and
-- 			C.x <= scrollbar_h_adj.get_value + scrollbar_h_adj.get_page_size then
-- 			result.x := true;
-- 			-- put_line ("X visible");	
-- 		end if;
-- 
-- 		
-- 		-- Y-axis:
-- 		-- The visible area ranges from the current position
-- 		-- of the vertical scrollbar (value) to the end of the
-- 		-- scrollbar (value + page_size). If C.y lies in that range,
-- 		-- then the corresponding flag in the return will be set.
-- 		if C.y >= scrollbar_v_adj.get_value and
-- 			C.y <= scrollbar_v_adj.get_value + scrollbar_v_adj.get_page_size then
-- 			result.y := true;
-- 			-- put_line ("Y visible");	
-- 		end if;
-- 
-- 		return result;
-- 	end model_point_visible;



	

	function get_visible_area (
		canvas	: access gtk_widget_record'class)
		return type_area
	is
		result : type_area;

		-- The allocation of the scrolled window:
		W : gtk_allocation;
		
		-- The allocation of the canvas:		
		L : gtk_allocation;

		
		h_start, h_length, h_end : gdouble;
		v_start, v_length, v_end : gdouble;

		-- The four corners of the visible area:
		BL, BR, TL, TR : type_point_model;
	begin
		-- Inquire the allocation of the scrolled window
		-- inside the main window:
		get_allocation (swin, W);

		-- Inquire the allocation of the canvas inside
		-- the scrolled window:
		get_allocation (canvas, L);

		
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
		-- position of the vertical scrollbar minus the
		-- y-position of the canvas:
		v_start := scrollbar_v_adj.get_value - gdouble (L.y);

		-- The visible area along the y-axis is as high as
		-- the scrolled window:
		v_length := gdouble (W.height);

		-- The visible area along the y-axis ends here:
		v_end := v_start + v_length;

		
		-- Compute the corners of the visible area:
		BL := to_model ((h_start, v_end), scale_factor, true);
		result.position := BL;

		BR := to_model ((h_end, v_end), scale_factor, true);
		TL := to_model ((h_start, v_start), scale_factor, true);
		TR := to_model ((h_end, v_start), scale_factor, true);

		-- put_line ("BL " & to_string (BL));
		-- put_line ("BR " & to_string (BR));
		-- put_line ("TR " & to_string (TR));
		--put_line ("TL " & to_string (TL));

		-- CS: more effective ?
		-- result.width    := type_distance_model (h_length) * type_distance_model (scale_factor);
		-- result.height   := type_distance_model (v_length) * type_distance_model (scale_factor);

		result.width := TR.x - TL.x;
		result.height := TL.y - BL.y;

		-- put_line ("visible area " & to_string (result));
		return result;
	end get_visible_area;

	

	-- procedure update_visible_area (
	-- 	canvas	: access gtk_widget_record'class)
	-- is begin
	-- 	-- put_line ("update visible area");
	-- 	visible_area := get_visible_area (canvas);
	-- 	put_line (" visible area " & to_string (visible_area));
 -- 
	-- 	visible_center := get_center (visible_area);
	-- 	-- put_line (" visible center " & to_string (visible_center));
	-- end update_visible_area;

	
	
	function cb_button_pressed_canvas (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean
	is
		use glib;
		event_handled : boolean := true;

		-- This is the point in the canvas where the operator
		-- has clicked:
		cp : constant type_point_canvas := (event.x, event.y);

		-- Convert the canvas point to the corresponding
		-- real model point:
		mp : constant type_point_model := to_model (
			point 	=> cp,
			scale	=> scale_factor,
			real	=> true);

		-- CS: For some reason the value of the scrollbars
		-- must be saved and restored if the canvas grabs the focus:
		h, v : gdouble;
		-- A solution might be:
		-- <https://stackoverflow.com/questions/26693042/gtkscrolledwindow-disable-scroll-to-focused-child>
		-- or
		-- <https://discourse.gnome.org/t/disable-auto-scrolling-in-gtkscrolledwindow-when-grab-focus-in-children/13058>
	begin
		put_line ("cb_button_pressed_canvas");

		-- Output the button id, x and y position:
		-- put_line ("cb_button_pressed_canvas "
		-- 	& " button" & guint'image (event.button) & " "
		-- 	& to_string (cp));

		-- Output the model point in the terminal:
		put_line (to_string (mp));

		-- Move the cursor to the nearest grid point:
		move_cursor (snap_to_grid (mp));


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
		
		refresh (canvas);
		
		return event_handled;
	end cb_button_pressed_canvas;



	
	
	function cb_mouse_moved (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_motion)
		return boolean
	is
		use glib;
		event_handled : boolean := true;

		cp : constant type_point_canvas := (event.x, event.y);

		-- Get the real model coordinates:
		mp : constant type_point_model := to_model (cp, scale_factor, true);
	begin
		null;
		-- output on the terminal:
		-- Output the x/y position of the pointer
		-- in logical and model coordinates:
		-- put_line (
			-- to_string (cp)
			-- & " " & to_string (mp)

		-- Update the coordinates display with the pointer position:
		gtk_entry (PC.position_x.get_child).set_text (to_string (mp.x));
		gtk_entry (PC.position_y.get_child).set_text (to_string (mp.y));
		
		return event_handled;
	end cb_mouse_moved;



	procedure move_cursor (
		destination : type_point_model)
	is
	begin
		cursor.position := destination;
		update_cursor_coordinates;
		
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

		-- Output the cursor position on the terminal:
		put_line ("cursor at " & to_string (cursor.position));
	end move_cursor;
	
	
	function cb_key_pressed_canvas (
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
		put_line ("cb_key_pressed_canvas "
			& " key " & gdk_key_type'image (event.keyval));

		if key_ctrl = control_mask then 
			null;
		else
			case key is
				when GDK_Right =>
					move_cursor (DIR_RIGHT);

				when GDK_Left =>
					move_cursor (DIR_LEFT);

				when GDK_Up =>
					move_cursor (DIR_UP);

				when GDK_Down =>
					move_cursor (DIR_DOWN);

				when others =>
					null;
			end case;
		end if;
		
		return event_handled;
	end cb_key_pressed_canvas;


	procedure cb_canvas_realized (
		canvas	: access gtk_widget_record'class)
	is
	begin
		null;
		-- put_line ("cb_canvas_realized");
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
		wheel_direction : constant gdk_scroll_direction := event.direction;


		procedure zoom is
			-- The given point on the canvas where the operator is zooming in or out:
			Z1 : constant type_point_canvas := (event.x, event.y);

			-- The corresponding virtual model-point
			-- according to the CURRENT (old) scale_factor:
			M : constant type_point_model := to_model (Z1, scale_factor);

			-- Get the corners of the bounding-box as it is BEFORE scaling:
			BC : constant type_area_corners := get_corners (bounding_box);


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

			
		begin -- zoom
			put_line (" zoom center (M)   " & to_string (M));
			put_line (" zoom center (Z1) " & to_string (Z1));
			put_line (" scale old" & to_string (scale_factor));
			
			case wheel_direction is
				when SCROLL_UP =>
					increase_scale;
					put_line (" zoom in");
					
				when SCROLL_DOWN => 
					decrease_scale;
					put_line (" zoom out");
					
				when others => null;
			end case;

			put_line (" scale new" & to_string (scale_factor));
			compute_translate_offset;
			
			update_scrollbar_limits (BC, scale_factor);
			-- backup_scrollbar_settings;

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
				dv := 10.0 * gdouble (scale_factor);
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
		end scroll;
		
		
	begin -- cb_mouse_wheel_rolled
		new_line;
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
			cp : type_point_canvas := to_canvas (origin, scale_factor, true);
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
				MP : type_point_model;
				CP : type_point_canvas;
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
						CP := to_canvas (MP, scale_factor, true);

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
				MP1 : type_point_model;
				MP2 : type_point_model;

				CP1 : type_point_canvas;
				CP2 : type_point_canvas;

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
					CP1 := to_canvas (MP1, scale_factor, true);
					CP2 := to_canvas (MP2, scale_factor, true);
					
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
					CP1 := to_canvas (MP1, scale_factor, true);
					CP2 := to_canvas (MP2, scale_factor, true);
					
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
			cp : type_point_canvas := to_canvas (cursor.position, scale_factor, true);

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
		
		
		cp : type_point_canvas;
		
	begin -- cb_draw_objects
		new_line;
		put_line ("cb_draw_objects " & image (clock));

		-- Update the global visible_area:
		visible_area := get_visible_area (canvas);
		-- put_line (" visible " & to_string (visible_area));

		-- Set the background color:
		-- set_source_rgb (context, 0.0, 0.0, 0.0); -- black
		set_source_rgb (context, 1.0, 1.0, 1.0); -- white
		paint (context);

		-- Draw the grid if it is enabled and if the spacing
		-- is greater than the minimal required spacing:
		if grid.on = GRID_ON and then
			get_grid_spacing (grid) >= grid_spacing_min then
			draw_grid;
		end if;
		
		draw_origin;

		draw_cursor;
		
		
		-- NOTE: In a real project, the database that contains
		-- all objects must be parsed here. One object after another
		-- must be drawn. But since this is a demo,
		-- we have just a single object (a rectangle) do deal with.
		
		
		set_line_width (context, 2.0);
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

