------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                    CALLBACK FUNCTIONS AND PROCEDURES                     --
--                                                                          --
--                               S p e c                                    --
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

with glib;						use glib;
with gdk.event;					use gdk.event;
with gtk.box;					use gtk.box;
with gtk.separator;				use gtk.separator;
with gtk.combo_box_text;		use gtk.combo_box_text;
with gtk.text_view;				use gtk.text_view;
with gtk.text_buffer;			use gtk.text_buffer;
with gtk.enums;
with gtk.gentry;				use gtk.gentry;
with gtk.window;				use gtk.window;
with gtk.widget;				use gtk.widget;
-- with gtk.button;				use gtk.button;
with gtk.table;					use gtk.table;
with gtk.label;					use gtk.label;
with gtk.scrolled_window;		use gtk.scrolled_window;
with gtk.adjustment;			use gtk.adjustment;
with gtk.scrollbar;				use gtk.scrollbar;
with gtk.drawing_area;			use gtk.drawing_area;
with cairo;						use cairo;

with geometry_1;				use geometry_1;
with geometry_2;				use geometry_2;


package callbacks is

	-- The place on the canvase where the model 
	-- coordinates system has its origin:
	base_offset : type_point_canvas;
		
	procedure compute_base_offset;

	
	-- The global translate-offset by which all draw operations on the canvas
	-- are translated when the operator zooms on the pointer or the cursor:
	T : type_point_canvas := (0.0, 0.0);

	-- This procedure updates the global translate-offset T.
	-- After changing the scale_factor (either by zoom on mouse pointer or
	-- by zoom on cursor), the translate_offset T must
	-- be calculated anew. The computation requires as input values
	-- the zoom center as virtual model point and as the corresponding
	-- canvas point.
	-- Later, when the actual drawing takes place (see function cb_draw_objects)
	-- the drawing will be dragged back by the translate_offset
	-- so that the operator gets the impression of a zoom-into or zoom-out effect.
	-- Without applying a translate_offset the drawing would be appearing as 
	-- expanding to the upper-right (on zoom-in) or shrinking toward the lower-left:
	procedure compute_translate_offset (
		MP	: in type_point_model;		-- the virtual zoom center as model point
		Z1	: in type_point_canvas);	-- the zoom center as canvas point

	
-- CONVERSION BETWEEN MODEL AND CANVAS:

	-- Converts the given model distance to
	-- a canvas distance according to the current scale_factor:
	function to_distance (
		d : in type_distance_model)
		return type_distance_canvas;

	
	-- Converts the given canvas distance to
	-- a model distance according to the current scale_factor:
	function to_distance (
		d : in type_distance_canvas)
		return type_distance_model;

	
	function to_model (
		point	: in type_point_canvas;
		scale	: in type_scale_factor;
		real 	: in boolean := false) -- if real model coordinates are required
		return type_point_model;
	

	function to_canvas (
		point 	: in type_point_model;
		scale	: in type_scale_factor;
		real	: in boolean := false) -- if real model coordinates are given
		return type_point_canvas;


	
	-- If an object occupies a space that is wider or
	-- higher than this constant, then it will be drawn on the screen:
	visibility_threshold : constant gdouble := 5.0;
	
	-- Returns true if the given area is large enough
	-- to display objects therein:
	function above_visibility_threshold (
		a : in type_area)
		return boolean;


-- GRID:
	
	-- This function returns the space between
	-- the grid columns or rows. It returns the lesser
	-- spacing of them. It calculates the spacing by this
	-- equation:
	-- x = grid.spacing.x * scale_factor
	-- y = grid.spacing.y * scale_factor
	-- Then the lesser one, either x or y will be returned:
	function get_grid_spacing (
		grid : in type_grid)
		return gdouble;




	
-- MAIN WINDOW:
	
	main_window	: gtk_window;

	type type_window_size is record
		width, height : positive := 1;
	end record;


-- BOXES:
	
	box_h 				: gtk_hbox;
	box_v1				: gtk_vbox;
	separator			: gtk_separator;

	table_coordinates	: gtk_table; -- incl. relative distances

	pointer_header							: gtk_label;
	pointer_x_label, pointer_y_label		: gtk_label;
	pointer_x_value, pointer_y_value		: gtk_text_view;
	pointer_x_buf, pointer_y_buf			: gtk_text_buffer;
	
	cursor_header							: gtk_label;
	cursor_x_label, cursor_y_label			: gtk_label;
	cursor_x_value, cursor_y_value			: gtk_text_view;
	cursor_x_buf, cursor_y_buf				: gtk_text_buffer;
	
	distances_header						: gtk_label;
	distances_dx_label, distances_dy_label	: gtk_label;
	distances_absolute_label				: gtk_label;
	distances_angle_label					: gtk_label;
	distances_dx_value, distances_dy_value	: gtk_text_view;
	distances_absolute_value				: gtk_text_view;
	distances_angle_value					: gtk_text_view;
	distances_dx_buf, distances_dy_buf		: gtk_text_buffer;
	distances_absolute_buf					: gtk_text_buffer;
	distances_angle_buf						: gtk_text_buffer;

	grid_header								: gtk_label;
	grid_x_label, grid_y_label				: gtk_label;
	grid_x_value, grid_y_value				: gtk_text_view;
	grid_x_buf, grid_y_buf					: gtk_text_buffer;

	scale_label								: gtk_label;
	scale_value								: gtk_text_view;
	scale_buf								: gtk_text_buffer;
	
	
	-- Updates the cursor coordinates display
	-- by the current cursor position:
	procedure update_cursor_coordinates;

	
	-- Updates the distances display:
	procedure update_distances_display;


	-- Updates the scale display:
	procedure update_scale_display;
	

	-- Updates the grid display:
	procedure update_grid_display;

	
	procedure cb_terminate (
		main_window : access gtk_widget_record'class);


	procedure cb_focus_win (
		main_window : access gtk_window_record'class);


	
	function cb_button_pressed_win (
		window	: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;


	-- Updates the limits of the scrollbars according to
	-- the given bounding-box area and scale factor:
	procedure update_scrollbar_limits (
		bounding_box_corners	: in type_area_corners;
		scale_factor			: in type_scale_factor);

	
	-- This callback procedure is called each time the size_allocate signal
	-- is emitted by the main window.
	procedure cb_main_window_size_allocate (
		window		: access gtk_widget_record'class;
		allocation	: gtk_allocation);

	
	procedure set_up_main_window;

	
	-- Creates the display for pointer/mouse and cursor position,
	-- distances and angle:
	procedure set_up_coordinates_display;

	
-- SCROLLED WINDOW:
	
	swin : gtk_scrolled_window;

	-- When the scrolled window is resized, then the canvas can be
	-- adjusted in several ways. Currently there are the modes known as follows:
	type type_scrolled_window_zoom_mode is (
		-- No zoom. No moving. Just more or less of 
		-- the canvas area is exposed:
		MODE_EXPOSE_CANVAS,

		-- Center of visible canvas area remains in the center. 
		-- Around the center more or less of the canvas area is exposed:
		MODE_KEEP_CENTER,

		-- Zooming according to the change of widht or height.
		-- Zoom center is the center of the visible area:
		MODE_ZOOM_CENTER);


	zoom_mode : constant type_scrolled_window_zoom_mode := 
		-- MODE_EXPOSE_CANVAS;
		MODE_KEEP_CENTER;
		-- MODE_ZOOM_CENTER;

	
	-- The current size of the scrolled window. It gets updated
	-- in procedure set_up_swin_and_scrollbars and 
	-- in cb_scrolled_window_size_allocate:
	scrolled_window_size : type_window_size;

	
	-- This callback procedure is called each time the size_allocate signal
	-- is emitted by the scrolled window.
	procedure cb_scrolled_window_size_allocate (
		window		: access gtk_widget_record'class;
		allocation	: gtk_allocation);
	

	
-- SCROLLBARS:
	
	scrollbar_h_adj, scrollbar_v_adj : gtk_adjustment;
	scrollbar_v, scrollbar_h : gtk_scrollbar;

	type type_scroll_direction is (
		SCROLL_UP,
		SCROLL_DOWN,
		SCROLL_RIGHT,
		SCROLL_LEFT);
	
	
	-- Called whenever the horizontal scrollbar is moved, either
	-- by the operator or by internal calls.
	procedure cb_horizontal_moved (
		scrollbar : access gtk_adjustment_record'class);

	
	-- Called whenever the vertical scrollbar is moved, either
	-- by the operator or by internal calls.
	procedure cb_vertical_moved (
		scrollbar : access gtk_adjustment_record'class);


	function cb_scrollbar_v_pressed (
		bar		: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;
	
	
	function cb_scrollbar_v_released (
		bar		: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;


	function cb_scrollbar_h_pressed (
		bar		: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;
	
	
	function cb_scrollbar_h_released (
		bar		: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;

	
	type type_scrollbar_settings is record
		lower		: gdouble;
		upper		: gdouble;
		value		: gdouble;
		page_size	: gdouble;
	end record;

	scrollbar_v_init : type_scrollbar_settings;
	scrollbar_h_init : type_scrollbar_settings;


	
	scrollbar_h_backup, scrollbar_v_backup : type_scrollbar_settings;

	procedure backup_scrollbar_settings;

	procedure restore_scrollbar_settings;

	
	
	procedure set_up_swin_and_scrollbars;

	procedure show_adjustments_v;
	procedure show_adjustments_h;

	procedure prepare_initial_scrollbar_settings;

	-- Applies the initial scrollbar settings.
	procedure apply_initial_scrollbar_settings;
	

	
-- CANVAS:
	
	canvas : gtk_drawing_area;

	procedure refresh (
		canvas	: access gtk_widget_record'class);


	procedure cb_canvas_size_allocate (
		canvas		: access gtk_widget_record'class;
		allocation	: gtk_allocation);


	
	type type_canvas_allocation is record
		x, y : natural := 0;
	end record;

	-- Here we track the allocation of the canvas inside the 
	-- main window: 
	-- CS: probably no need ?
	canvas_allocation : type_canvas_allocation;

	
	
	procedure show_canvas_size;
	
	procedure set_up_canvas;
		

	-- The directions into which the an object can be moved
	-- by means of the cursor keys (arrow keys):
	type type_direction is (DIR_RIGHT, DIR_LEFT, DIR_UP, DIR_DOWN);

	
	-- Shifts the canvas into the given direction
	-- by the given distance:
	procedure shift_canvas (
		direction	: type_direction;
		distance	: type_distance_model);
	
		
-- POINT QUERY AND TEST:

	-- CS no need anymore ?
	-- type type_model_point_visible is record
	-- 	x, y : boolean := false;
	-- end record;
 -- 
	-- -- CS no need anymore ? rework required. use in_area test instead ?	
	-- function model_point_visible (
	-- 	point 		: in type_point_model)
	-- 	return type_model_point_visible;
	



	
	

	-- Returns the currently visible area of the model.
	-- The visible area depends the current scale factor,
	-- base-offset, translate-offset, allocation of the canvas,
	-- allocation of the scrolled window
	-- and the current settings of the scrollbars.
	function get_visible_area (
		canvas	: access gtk_widget_record'class)
		return type_area;

	

	-- This visible area is a global variable.
	-- It is updated by procedure cb_draw_objects.
	-- The reason why it is global: If the user searches for a
	-- particular object, then the result of a search could be
	-- a message like "The object is outside the visible
	-- area at position (x/y)."
	visible_area : type_area;
	


-- CURSOR:
	-- The cursor is a crosshair that can be moved by the
	-- cursor keys (arrow keys) about the canvas:
	type type_cursor is record
		position	: type_point_model := origin;
		linewidth_1	: gdouble := 1.0;
		linewidth_2	: gdouble := 4.0;
		length_1	: gdouble := 20.0;
		length_2	: gdouble := 20.0;
		radius		: gdouble := 25.0;
		-- CS blink, color, ...
	end record;

	cursor : type_cursor;



	
	-- This procedure moves the cursor to the given destination:
	procedure move_cursor (
		destination : type_point_model);


	-- This procedure moves the cursor into the given direction:
	procedure move_cursor (
		direction : type_direction);


	type type_zoom_direction is (ZOOM_IN, ZOOM_OUT);

	-- Zooms in or out at the current cursor position:
	procedure zoom_on_cursor (
		direction : type_zoom_direction);
	
	
	-- This callback function is called each time the operator
	-- clicks on the canvas.
	-- It sets the focus on the canvas and moves the cursor
	-- to the place where the operator has clicked the canvas.
	function cb_button_pressed_canvas (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;

	
	function cb_mouse_moved (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_motion)
		return boolean;


	-- This callback function is called each time the
	-- operator hits a key and if the canvas has the focus:
	function cb_key_pressed_canvas (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_key)
		return boolean;


	procedure cb_canvas_realized (
		canvas	: access gtk_widget_record'class);
	




	-- This function is called each time the mouse wheel is
	-- rolled by the operator:
	function cb_mouse_wheel_rolled (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_scroll)
		return boolean;


	-- This is a primitive draw operation that draws a line:
	procedure draw_line (
		context	: in cairo_context; -- CS make context global ?
		line	: in geometry_2.type_line;
		pos		: in type_point_model);

	
	-- This function is called each time the canvas is to be refreshed:
	function cb_draw_objects (
		canvas	: access gtk_widget_record'class;
		context	: in cairo_context)
		return boolean;
	
end callbacks;

