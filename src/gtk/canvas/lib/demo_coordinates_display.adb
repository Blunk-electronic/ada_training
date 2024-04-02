------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                           COORDINATES DISPLAY                            --
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

with ada.text_io;				use ada.text_io;
with glib;
with gtk.box;					use gtk.box;
with gtk.enums;					use gtk.enums;

with demo_logical_pixels;		use demo_logical_pixels;
with demo_geometry;				use demo_geometry;
with demo_zoom;					use demo_zoom;
with demo_main_window;			use demo_main_window;
with demo_cursor;
with demo_canvas;
with demo_grid;
with demo_conversions;			use demo_conversions;
with demo_scale;


package body demo_coordinates_display is


	procedure set_up_coordinates_display is
		use glib;
		
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
		gtk_new (table, rows => 11, columns => 2, 
			homogeneous => false);
		-- table.set_col_spacings (50);
		-- table.set_border_width (10);

		-- The table shall not expand downward:
		box_v1.pack_start (table, expand => false);


		-- POINTER / MOUSE:
		gtk_new (pointer_header, "POINTER");		
		gtk_new (pointer_x_label, "x:"); -- create a text label

		-- The label shall be aligned in the column.
		-- The discussion at:
		-- <https://stackoverflow.com/questions/26345989/
		-- gtk-how-to-align-a-label-to-the-left-in-a-table>
		-- gave the solution. See also package gtk.misc for details:
		pointer_x_label.set_alignment (0.0, 0.0);	
		gtk_new (pointer_x_value); -- create a text view vor the value
		-- A minimum width must be set for the text.
		-- Setting the size request is one way. The height is
		-- not affected, therefore the value -1:
		pointer_x_value.set_size_request (pos_field_width_min, -1);
		-- See also discussion at:
		-- <https://stackoverflow.com/questions/24412859/
		-- gtk-how-can-the-size-of-a-textview-be-set-manually>
		-- for a way to achieve this using a tag.

		gtk_new (pointer_x_buf); -- create a text buffer

		-- align the value left
		pointer_x_value.set_justification (JUSTIFY_RIGHT);
		pointer_x_value.set_editable (false); -- the value is not editable
		pointer_x_value.set_cursor_visible (false); -- do not show a cursor

		gtk_new (pointer_y_label, "y:"); -- create a text label
		pointer_y_label.set_alignment (0.0, 0.0);	
		gtk_new (pointer_y_value);
		pointer_y_value.set_size_request (pos_field_width_min, -1);
		gtk_new (pointer_y_buf); -- create a text buffer
		
		-- align the value left
		pointer_y_value.set_justification (JUSTIFY_RIGHT); 
		pointer_y_value.set_editable (false); -- the value is not editable
		pointer_y_value.set_cursor_visible (false); -- do not show a cursor

		----------------------------------------------------------------------
		
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

		----------------------------------------------------------------------
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

		----------------------------------------------------------------------
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

		----------------------------------------------------------------------
		-- ZOOM FACTOR
		-- gtk_new (zoom_header, "ZOOM");
		gtk_new (zoom_label, "zoom:");
		zoom_label.set_alignment (0.0, 0.0);	
		gtk_new (zoom_value);
		zoom_value.set_size_request (pos_field_width_min, -1);

		gtk_new (zoom_buf);
		zoom_value.set_justification (JUSTIFY_RIGHT);
		zoom_value.set_editable (false);
		zoom_value.set_cursor_visible (false);

		----------------------------------------------------------------------
		-- SCALE
		gtk_new (scale_label, "scale:");
		scale_label.set_alignment (0.0, 0.0);	
		gtk_new (scale_value);
		scale_value.set_size_request (pos_field_width_min, -1);

		gtk_new (scale_buf);
		scale_value.set_justification (JUSTIFY_RIGHT);
		scale_value.set_editable (false);
		scale_value.set_cursor_visible (false);
		
		----------------------------------------------------------------------
		-- Put the items in the table:

		-- MOUSE / POINTER:
		table.attach (pointer_header, 
			left_attach	=> 0, right_attach	=> 2, 
			top_attach	=> 0, bottom_attach	=> 1);

		-- x-coordinate:
		table.attach (pointer_x_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 1, bottom_attach	=> 2);

		table.attach (pointer_x_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 1, bottom_attach	=> 2);

		-- y-coordinate:
		table.attach (pointer_y_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 2, bottom_attach	=> 3);
  
		table.attach (pointer_y_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 2, bottom_attach	=> 3);


		-- CURSOR:
		table.attach (cursor_header, 
			left_attach	=> 0, right_attach	=> 2, 
			top_attach	=> 3, bottom_attach	=> 4);

		-- x-coordinate:
		table.attach (cursor_x_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 4, bottom_attach	=> 5);

		table.attach (cursor_x_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 4, bottom_attach	=> 5);

		-- y-coordinate:
		table.attach (cursor_y_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 5, bottom_attach	=> 6);
  
		table.attach (cursor_y_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 5, bottom_attach	=> 6);



		-- DISTANCES:
		table.attach (distances_header, 
			left_attach	=> 0, right_attach	=> 2, 
			top_attach	=> 6, bottom_attach	=> 7);

		-- x-coordinate:
		table.attach (distances_dx_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 7, bottom_attach	=> 8);

		table.attach (distances_dx_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 7, bottom_attach	=> 8);

		-- y-coordinate:
		table.attach (distances_dy_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 9, bottom_attach	=> 10);
  
		table.attach (distances_dy_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 9, bottom_attach	=> 10);

		-- absolute:
		table.attach (distances_absolute_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 10, bottom_attach => 11);
  
		table.attach (distances_absolute_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 10, bottom_attach => 11);
		
		-- angle:
		table.attach (distances_angle_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 11, bottom_attach => 12);
  
		table.attach (distances_angle_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 11, bottom_attach => 12);


		
		-- GRID:
		table.attach (grid_header, 
			left_attach	=> 0, right_attach	=> 2, 
			top_attach	=> 12, bottom_attach => 13);

		-- x-axis:
		table.attach (grid_x_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 13, bottom_attach => 14);
  
		table.attach (grid_x_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 13, bottom_attach => 14);

		-- y-axis:
		table.attach (grid_y_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 14, bottom_attach => 15);
  
		table.attach (grid_y_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 14, bottom_attach => 15);

		
		-- ZOOM:
		table.attach (zoom_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 15, bottom_attach => 16);
  
		table.attach (zoom_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 15, bottom_attach => 16);

		
		-- SCALE:
		table.attach (scale_label, 
			left_attach	=> 0, right_attach	=> 1, 
			top_attach	=> 16, bottom_attach => 17);
  
		table.attach (scale_value, 
			left_attach	=> 1, right_attach	=> 2, 
			top_attach	=> 16, bottom_attach => 17);

	end set_up_coordinates_display;


	procedure update_cursor_coordinates is 
		use demo_scale;
		use demo_cursor;
	begin
		-- x-axis:
		cursor_x_buf.set_text (to_string (to_reality (cursor.position.x)));
		cursor_x_value.set_buffer (cursor_x_buf);
 
		-- y-axis:
		cursor_y_buf.set_text (to_string (to_reality (cursor.position.y)));
		cursor_y_value.set_buffer (cursor_y_buf);
	end update_cursor_coordinates;


	
	procedure update_distances_display is 
		use glib;
		use demo_cursor;
		use demo_canvas;
		use demo_scale;
		
		px, py : gint; -- the pointer position
		cp : type_logical_pixels_vector;
		mp : type_vector_model;

		dx, dy : type_distance_model;
		dabs : type_distance_model;
		angle : type_rotation_model;
	begin
		-- Get the current pointer/mouse position:
		canvas.get_pointer (px, py);
		cp := (type_logical_pixels (px), type_logical_pixels (py));
		
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
		distances_dx_buf.set_text (to_string (to_reality (dx)));
		distances_dx_value.set_buffer (distances_dx_buf);

		-- dy:
		distances_dy_buf.set_text (to_string (to_reality (dy)));
		distances_dy_value.set_buffer (distances_dy_buf);

		-- absolute:
		distances_absolute_buf.set_text (to_string (to_reality (dabs)));
		distances_absolute_value.set_buffer (distances_absolute_buf);

		-- angle:
		distances_angle_buf.set_text (to_string (angle));
		distances_angle_value.set_buffer (distances_angle_buf);
	end update_distances_display;



	procedure update_zoom_display is begin
		zoom_buf.set_text (to_string (S));
		zoom_value.set_buffer (zoom_buf);
	end update_zoom_display;



	procedure update_grid_display is 
		use demo_grid;
		use demo_scale;
	begin
		-- x-axis:
		grid_x_buf.set_text (to_string (to_reality (grid.spacing.x)));
		grid_x_value.set_buffer (grid_x_buf);

		-- y-axis:
		grid_y_buf.set_text (to_string (to_reality (grid.spacing.y)));
		grid_y_value.set_buffer (grid_y_buf);
	end update_grid_display;

	
	procedure update_scale_display is 
		use demo_grid;
		use demo_scale;
	begin
		scale_buf.set_text (to_string (M));
		scale_value.set_buffer (scale_buf);
	end update_scale_display;


	
end demo_coordinates_display;

