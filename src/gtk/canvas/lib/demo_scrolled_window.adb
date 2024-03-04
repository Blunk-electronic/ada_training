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

with glib;						use glib;
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



	procedure set_initial_scrollbar_settings is
		use demo_base_offset;		
		use demo_bounding_box;
		
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


	
	
end demo_scrolled_window;

