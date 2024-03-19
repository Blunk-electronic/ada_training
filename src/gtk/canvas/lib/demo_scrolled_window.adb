------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                            SCROLLED WINDOW                               --
--                                                                          --
--                                B o d y                                   --
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

with ada.text_io;				use ada.text_io;

-- with glib;						use glib;
with gtk.widget;				use gtk.widget;
with gtk.window;				use gtk.window;
with gtk.enums;					use gtk.enums;
with gtk.scrolled_window;		use gtk.scrolled_window;
with gtk.adjustment;			use gtk.adjustment;
with gtk.scrollbar;				use gtk.scrollbar;

with demo_window_dimensions;	use demo_window_dimensions;
with demo_base_offset;
with demo_bounding_box;



package body demo_scrolled_window is

	
	procedure create_scrolled_window_and_scrollbars is
	begin
		put_line ("create_scrolled_window");

		-- Create a scrolled window:
		swin := gtk_scrolled_window_new (
			hadjustment => null, vadjustment => null);

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
		-- 	gint (bounding_box.height)); -- Mind a minimal height !
		--  -- See above comment.
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

		
	end create_scrolled_window_and_scrollbars;

	

	procedure backup_scrollbar_settings is begin
		--put_line ("backup_scrollbar_settings");
		scrollbar_h_backup.lower := to_lp (scrollbar_h_adj.get_lower);
		scrollbar_h_backup.value := to_lp (scrollbar_h_adj.get_value);
		scrollbar_h_backup.page_size := to_lp (scrollbar_h_adj.get_page_size);
		scrollbar_h_backup.upper := to_lp (scrollbar_h_adj.get_upper);

		scrollbar_v_backup.lower := to_lp (scrollbar_v_adj.get_lower);
		scrollbar_v_backup.value := to_lp (scrollbar_v_adj.get_value);
		scrollbar_v_backup.page_size := to_lp (scrollbar_v_adj.get_page_size);
		scrollbar_v_backup.upper := to_lp (scrollbar_v_adj.get_upper);
	end backup_scrollbar_settings;
	

	procedure restore_scrollbar_settings is begin
		scrollbar_h_adj.set_lower (to_gdouble (scrollbar_h_backup.lower));
		scrollbar_h_adj.set_value (to_gdouble (scrollbar_h_backup.value));
		
		scrollbar_h_adj.set_page_size (
			to_gdouble (scrollbar_h_backup.page_size));
		
		scrollbar_h_adj.set_upper (to_gdouble (scrollbar_h_backup.upper));

		scrollbar_v_adj.set_lower (to_gdouble (scrollbar_v_backup.lower));
		scrollbar_v_adj.set_value (to_gdouble (scrollbar_v_backup.value));

		scrollbar_v_adj.set_page_size (
			to_gdouble (scrollbar_v_backup.page_size));

		scrollbar_v_adj.set_upper (to_gdouble (scrollbar_v_backup.upper));
	end restore_scrollbar_settings;



	procedure set_initial_scrollbar_settings is
		use demo_base_offset;		
		use demo_bounding_box;
		
		debug : boolean := false;
		-- debug : boolean := true;
	begin
		put_line ("set initial scrollbar settings");
		
		scrollbar_v_init.upper := - F.y;			
		
		scrollbar_v_init.lower := scrollbar_v_init.upper - 
			type_logical_pixels (bounding_box.height);
		
		scrollbar_v_init.page_size := 
			type_logical_pixels (bounding_box.height);
		
		scrollbar_v_init.value := scrollbar_v_init.lower;

		if debug then
			put_line (" vertical:");
			put_line ("  lower" & 
				to_string (scrollbar_v_init.lower));

			put_line ("  upper" & 
				to_string (scrollbar_v_init.upper));

			put_line ("  page " & 
				to_string (scrollbar_v_init.page_size));

			put_line ("  value" & 
				to_string (scrollbar_v_init.value));
		end if;
		
		scrollbar_h_init.lower := F.x;
		scrollbar_h_init.upper := scrollbar_h_init.lower + 
			type_logical_pixels (bounding_box.width);
		
		scrollbar_h_init.page_size := 
			type_logical_pixels (bounding_box.width);
		
		scrollbar_h_init.value := scrollbar_h_init.lower;

		if debug then
			put_line (" horizontal:");
			put_line ("  lower" & 
				to_string (scrollbar_h_init.lower));

			put_line ("  upper" &
				to_string (scrollbar_h_init.upper));

			put_line ("  page " & 
				to_string (scrollbar_h_init.page_size));

			put_line ("  value" & 
				to_string (scrollbar_h_init.value));
		end if;

	
		----------------------------------------------------------------------
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
-- 				-- put_line ("x/y : " & gint'image (a.x) & "/" 
-- 					& gint'image (a.y));
-- 			end if;
-- 		end;
		----------------------------------------------------------------------

		
		-- put_line ("vertical:");
		scrollbar_v_adj.set_upper (to_gdouble (scrollbar_v_init.upper));
		scrollbar_v_adj.set_lower (to_gdouble (scrollbar_v_init.lower));
		
		scrollbar_v_adj.set_page_size (
			to_gdouble (scrollbar_v_init.page_size));

		scrollbar_v_adj.set_value (to_gdouble (scrollbar_v_init.value));

		-- put_line ("horizontal:");
		scrollbar_h_adj.set_upper (to_gdouble (scrollbar_h_init.upper));
		scrollbar_h_adj.set_lower (to_gdouble (scrollbar_h_init.lower));

		scrollbar_h_adj.set_page_size (
			to_gdouble (scrollbar_h_init.page_size));

		scrollbar_h_adj.set_value (to_gdouble (scrollbar_h_init.value));

		-- show_adjustments_h;
		-- show_adjustments_v;
		
		backup_scrollbar_settings;
		
	end set_initial_scrollbar_settings;

	
	

	procedure show_adjustments_v is 
		v_lower : type_logical_pixels := 
			to_lp (scrollbar_v_adj.get_lower);

		v_value : type_logical_pixels := 
			to_lp (scrollbar_v_adj.get_value);

		v_upper : type_logical_pixels := 
			to_lp (scrollbar_v_adj.get_upper);

		v_page  : type_logical_pixels := 
			to_lp (scrollbar_v_adj.get_page_size);
		
	begin
		put_line ("vertical scrollbar adjustments:");
		put_line (" lower" & to_string (v_lower));
		put_line (" value" & to_string (v_value));
		put_line (" page " & to_string (v_page));
		put_line (" upper" & to_string (v_upper));
	end show_adjustments_v;
				  

	procedure show_adjustments_h is 
		h_lower : type_logical_pixels := to_lp (scrollbar_h_adj.get_lower);
		h_value : type_logical_pixels := to_lp (scrollbar_h_adj.get_value);
		h_upper : type_logical_pixels := to_lp (scrollbar_h_adj.get_upper);
		
		h_page  : type_logical_pixels := 
			to_lp (scrollbar_h_adj.get_page_size);
	begin
		put_line ("horizontal scrollbar adjustments:");
		put_line (" lower" & to_string (h_lower));
		put_line (" value" & to_string (h_value));
		put_line (" page " & to_string (h_page));
		put_line (" upper" & to_string (h_upper));
	end show_adjustments_h;



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
		sw := type_scale_factor 
			(type_distance_model (a.width) / area.width);
		
		sh := type_scale_factor 
			(type_distance_model (a.height) / area.height);

		-- CS: Alternatively the ratio can be based on the initial dimensions
		-- of the scrolled window. A boolean argument for this function 
		-- could be used to switch between current dimensions and initial 
		-- dimensions:
		-- sw := type_scale_factor 
		-- 	(type_distance_model (swin_size_initial.width) / area.width);
		-- sh := type_scale_factor 
		--	(type_distance_model (swin_size_initial.height) / area.height);
		
		-- put_line ("sw: " & to_string (sw));
		-- put_line ("sh: " & to_string (sh));

		-- The smaller of sw and sh has the final say:
		return type_scale_factor'min (sw, sh);
	end get_ratio;
	


	procedure update_scrollbar_limits (
		C1, C2 : in type_bounding_box_corners)
	is
		debug : boolean := false;
		scratch : type_logical_pixels;

		HL : type_logical_pixels := to_lp (scrollbar_h_adj.get_lower);
		HU : type_logical_pixels := to_lp (scrollbar_h_adj.get_upper);

		VL : type_logical_pixels := to_lp (scrollbar_v_adj.get_lower);
		VU : type_logical_pixels := to_lp (scrollbar_v_adj.get_upper);

		dHL, dHU : type_logical_pixels;
		dVL, dVU : type_logical_pixels;
	begin
		if debug then
			put_line ("VL     " & to_string (VL));
			put_line ("VU     " & to_string (VU));

			put_line ("C1.TL.y" & to_string (C1.TL.y));
			put_line ("C1.BL.y" & to_string (C1.BL.y));

			put_line ("C2.TL.y" & to_string (C2.TL.y));
			put_line ("C2.BL.y" & to_string (C2.BL.y));
		end if;
		
		dHL := C2.BL.x - C1.BL.x;
		dHU := C2.BR.x - C1.BR.x;

		dVL := C2.TL.y - C1.TL.y;
		dVU := C2.BL.y - C1.BL.y;

		if debug then
			put_line ("dVL    " & to_string (dVL));
			put_line ("dVU    " & to_string (dVU));
		end if;
		

		-- horizontal:

		-- The left end of the scrollbar is the same as the position
		-- (value) of the scrollbar.
		-- If the left edge of the bounding-box is farther to the
		-- left than the left end of the bar, then the lower limit
		-- moves to the left. It assumes the value of the left edge
		-- of the bounding-box:
		HL := HL + dHL;
		if HL <= to_lp (scrollbar_h_adj.get_value) then
			clip_min (HL, 0.0); -- suppress negative value
			scrollbar_h_adj.set_lower (to_gdouble (HL));
		else
		-- If the left edge of the box is farther to the right than
		-- the left end of the bar, then the lower limit can not be
		-- moved further to the right. So the lower limit can at most assume
		-- the value of the left end of the bar:
			scrollbar_h_adj.set_lower (scrollbar_h_adj.get_value);
		end if;

		-- The right end of the scrollbar is the sum of its position (value)
		-- and its length (page size):
		scratch := to_lp (scrollbar_h_adj.get_value + 
						  scrollbar_h_adj.get_page_size);
		
		HU := HU + dHU;
		-- CS clip_max (HU, type_logical_pixels (scrolled_window_size.width));
		-- If the right edge of the bounding-box is farther to the
		-- right than the right end of the bar, then the upper limit
		-- moves to the right. It assumes the value of the right edge
		-- of the bounding-box:
		if HU >= scratch then
			scrollbar_h_adj.set_upper (to_gdouble (HU));
		else
		-- If the right edge of the box is farther to the left than
		-- the right end of the bar, then the upper limit can not be
		-- moved further to the left. So the upper limit can at most assume
		-- the value of the right end of the bar:
			scrollbar_h_adj.set_upper (to_gdouble (scratch));
		end if;

		
		-- vertical:

		-- The upper end of the scrollbar is the same as the position
		-- (value) of the scrollbar.
		-- If the upper edge of the bounding-box is higher
		-- than the upper end of the bar, then the lower limit
		-- moves upwards. It assumes the value of the upper edge
		-- of the bounding-box:
		VL := VL + dVL;
		if VL <= to_lp (scrollbar_v_adj.get_value) then
			clip_min (VL, 0.0); -- suppress negative value
			scrollbar_v_adj.set_lower (to_gdouble (VL));
		else
		-- If the upper edge of the box is below
		-- the upper end of the bar, then the lower limit can not be
		-- moved further upwards. So the lower limit can at most assume
		-- the value of the upper end of the bar:
			scrollbar_v_adj.set_lower (scrollbar_v_adj.get_value);
		end if;

		-- The lower end of the scrollbar is the sum of its position (value)
		-- and its length (page size):
		scratch := to_lp (scrollbar_v_adj.get_value + 
						  scrollbar_v_adj.get_page_size);
		
		VU := VU + dVU;
		-- CS clip_max (VU, 
		--   type_logical_pixels (scrolled_window_size.height));
		-- If the lower edge of the bounding-box is below the
		-- lower end of the bar, then the upper limit
		-- moves further downwards. It assumes the value of the lower edge
		-- of the bounding-box:
		if VU >= scratch then
			scrollbar_v_adj.set_upper (to_gdouble (VU));
		else
		-- If the lower edge of the box is above
		-- the lower end of the bar, then the upper limit can not be
		-- moved further downwards. So the upper limit can at most assume
		-- the value of the lower end of the bar:
			scrollbar_v_adj.set_upper (to_gdouble (scratch));
		end if;

		-- show_adjustments_v;
	end update_scrollbar_limits;

	
end demo_scrolled_window;

