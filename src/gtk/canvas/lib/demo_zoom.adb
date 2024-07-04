------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                                 ZOOM                                     --
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

with cairo;

with demo_base_offset;			use demo_base_offset;
with demo_translate_offset;		use demo_translate_offset;
with demo_conversions;			use demo_conversions;
with demo_visible_area;
with demo_coordinates_display;
with demo_cursor;
with demo_canvas;
with demo_scrolled_window;
with demo_bounding_box;




package body demo_zoom is


	function to_string (
		zf : in type_zoom_factor)
		return string
	is begin
		return type_zoom_factor'image (zf);
	end to_string;
	
	
	procedure increase_zoom_factor is begin
		S := S * SM;
		
		exception 
			when constraint_error =>
				put_line ("upper zoom limit reached");
			when others => null;
	end increase_zoom_factor;

	
	procedure decrease_zoom_factor is begin
		S := S / SM;
		
		exception 
			when constraint_error => 
				put_line ("lower zoom limit reached");
			when others => null;
	end decrease_zoom_factor;


	

	procedure set_translation_for_zoom (
		S1	: in type_zoom_factor;
		S2	: in type_zoom_factor;
		Z1	: in type_logical_pixels_vector) -- a canvas point
	is 
		debug : boolean := false;

		-- Convert the given canvas point to a
		-- virtual model point according to the old zoom factor:
		V : constant type_vector_model := canvas_to_virtual (Z1, S1);

		Z2 : type_logical_pixels_vector;
	begin			
		if debug then
			put_line ("set_translation_for_zoom");
		end if;

		-- Starting at the virtual model point V,
		-- compute the prospected canvas point according to the 
		-- new zoom factor. 
		-- The current translate-offset will NOT be taken into account:
		Z2 := virtual_to_canvas (V, S2, false);

		-- This is the offset from Z1 to the prospected
		-- point Z2. The offset must be multiplied by -1 because the
		-- drawing must be dragged-back to the given pointer position:
		T.x := -(Z2.x - Z1.x);
		T.y := -(Z2.y - Z1.y);
		-- CS simplify or use vector mathematics specified in 
		-- package demo_logical_pixels

		if debug then
			put_line (" T: " & to_string (T));
		end if;
	end set_translation_for_zoom;


	

	procedure set_translation_for_zoom (
		S1	: in type_zoom_factor;
		S2	: in type_zoom_factor;
		M	: in type_vector_model) -- real model point
	is 
		debug : boolean := false;
		
		-- Convert the given real model point to 
		-- a virtual model point:
		V : constant type_vector_model := to_virtual (M);
		
		Z1, Z2 : type_logical_pixels_vector;		
	begin			
		if debug then
			put_line ("set_translation_for_zoom");
		end if;

		-- Convert the virtual model point to a canvas point
		-- according to the old zoom factor.
		-- The current translate-offset will NOT be taken into account:
		Z1 := virtual_to_canvas (V, S1, translate => true);
		
		-- Compute the prospected canvas point according to the 
		-- new zoom factor.
		-- The current translate-offset will NOT be taken into account:
		Z2 := virtual_to_canvas (V, S2, translate => false);
		-- put_line ("Z2 " & to_string (Z2));

		-- This is the offset from point Z1 to the prospected
		-- point Z2. The offset must be multiplied by -1 because the
		-- drawing must be dragged-back to the given pointer position:
		T.x := -(Z2.x - Z1.x);
		T.y := -(Z2.y - Z1.y);
		-- CS simplify or use vector mathematics specified in 
		-- package demo_logical_pixels
		
		if debug then
			put_line (" T: " & to_string (T));
		end if;
	end set_translation_for_zoom;



	procedure reset_zoom_area is begin
		put_line ("reset_zoom_area");
		zoom_area := (others => <>);
	end reset_zoom_area;



	procedure zoom_on_cursor (
		direction : in type_zoom_direction)
	is
		use demo_visible_area;
		use demo_coordinates_display;
		use demo_cursor;
		use demo_canvas;
		use demo_scrolled_window;
		
		S1 : constant type_zoom_factor := S;

		-- The corners of the bounding-box on the canvas before 
		-- and after zooming:
		C1, C2 : type_bounding_box_corners;
	begin
		put_line ("zoom_on_cursor " & type_zoom_direction'image (direction));

		C1 := get_bounding_box_corners;

		case direction is
			when ZOOM_IN =>
				increase_zoom_factor;
				put_line (" zoom in");
				
			when ZOOM_OUT => 
				decrease_zoom_factor;
				put_line (" zoom out");
				
			when others => null;
		end case;

		update_zoom_display;
		
		-- put_line (" S" & to_string (S));

		-- After changing the zoom factor, the translate-offset must
		-- be calculated anew. When the actual drawing takes 
		-- place (see function cb_draw_objects)
		-- then the drawing will be dragged back by the translate-offset
		-- so that the operator gets the impression of a zoom-into or 
		-- zoom-out effect.
		-- Without applying a translate-offset the drawing would be appearing
		-- as expanding to the upper-right (on zoom-in) or shrinking toward 
		-- the lower-left:
		set_translation_for_zoom (S1, S, cursor.position);

		C2 := get_bounding_box_corners;
		update_scrollbar_limits (C1, C2);

		-- show_adjustments_v;

		backup_visible_area (get_visible_area (canvas));
		
		-- schedule a redraw:
		refresh;		
	end zoom_on_cursor;


	

	procedure zoom_to_fit (
		area : in type_area)
	is
		use demo_visible_area;
		use demo_scrolled_window;
		use demo_coordinates_display;
		
		debug : boolean := false;
	begin
		put_line ("zoom_to_fit");

		-- Calculate the zoom factor that is required to
		-- fit the given area into the scrolled window:
		S := get_ratio (area);
		
		if debug then
			put_line (" S: " & type_zoom_factor'image (S));
		end if;

		update_zoom_display;
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
		use demo_bounding_box;
		use demo_visible_area;
		use demo_scrolled_window;
		use demo_coordinates_display;
		use demo_canvas;
		
		-- debug : boolean := true;
		debug : boolean := false;
	begin
		-- put_line ("zoom_to_fit");

		-- Reset the translate-offset:
		T := (0.0, 0.0);
		
		-- Compute the new bounding-box. Update global
		-- variable bounding_box:
		compute_bounding_box;

		-- In order to simulate a violation of the maximal
		-- size of the bounding-box try this:
		-- compute_bounding_box (ignore_errors => true);
		-- compute_bounding_box (test_only => true, ignore_errors => true);

		-- Compute the new base-offset. Update global variable F:
		set_base_offset;

		-- Since the bounding_box has changed, the scrollbars
		-- must be reinitialized:
		set_initial_scrollbar_settings;

		-- Calculate the zoom factor that is required to
		-- fit all objects into the scrolled window:
		S := get_ratio (bounding_box);

		
		
		if debug then
			put_line (" S: " & type_zoom_factor'image (S));
		end if;

		update_zoom_display;


		-- Calculate the translate-offset that is required to
		-- "move" all objects to the center of the visible area:
		center_to_visible_area (bounding_box);

		backup_visible_area (bounding_box);
		
		-- Schedule a redraw of the canvas:
		refresh;
	end zoom_to_fit_all;
	


	procedure draw_zoom_area is
		use cairo;
		use demo_canvas;
		
		x, y : type_logical_pixels;
		w, h : type_logical_pixels;

		l1 : type_logical_pixels_vector renames zoom_area.l1;
		l2 : type_logical_pixels_vector renames zoom_area.l2;
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

			set_line_width (context, to_gdouble (zoom_area_linewidth));
			
			rectangle (context, 
				to_gdouble (x),
				to_gdouble (y),
				to_gdouble (w),
				to_gdouble (h));
				
			stroke;
		end if;
	end draw_zoom_area;
	
end demo_zoom;

