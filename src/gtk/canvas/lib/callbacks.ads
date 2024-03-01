------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                    CALLBACK FUNCTIONS AND PROCEDURES                     --
--                                                                          --
--                               S p e c                                    --
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
with gtk.button;				use gtk.button;
with gtk.table;					use gtk.table;
with gtk.label;					use gtk.label;
with gtk.scrolled_window;		use gtk.scrolled_window;
with gtk.adjustment;			use gtk.adjustment;
with gtk.scrollbar;				use gtk.scrollbar;
with gtk.drawing_area;			use gtk.drawing_area;
with cairo;						use cairo;

with geometry_1;				use geometry_1;
with geometry_2;				use geometry_2;
with demo_objects;				use demo_objects;


package callbacks is

-- BASE-OFFSET:
	
	-- The place on the canvase where the model 
	-- coordinates system has its origin.
	-- It is a global variable. We call it "base-offset":
	F : type_vector_gdouble;

	-- Sets the global base-offset F according to the current
	-- bounding-box and the maximal allowed scale-factor:
	procedure set_base_offset;


	
-- TRANSLATE-OFFSET:
	
	-- The global translate-offset by which all draw operations on the canvas
	-- are translated when the operator zooms on the pointer or the cursor:
	T : type_vector_gdouble := (0.0, 0.0);

	-- This procedure sets the global translate-offset T that is
	-- required for a zoom-operation.
	-- After changing the scale-factor S (either by zoom on mouse pointer or
	-- by zoom on cursor), the translate-offset T must
	-- be calculated anew. The computation requires as input values
	-- the zoom center as virtual model point (CS1) or as canvas point (CS2).
	-- So there is a procedure set_translation_for_zoom that takes a canvas point
	-- and another that takes a real model point.
	-- Later, when the actual drawing takes place (see function cb_draw_objects)
	-- the drawing will be dragged back by the translate-offset
	-- so that the operator gets the impression of a zoom-into or zoom-out effect.
	-- Without applying a translate-offset the drawing would be appearing as 
	-- expanding to the upper-right (on zoom-in) or shrinking toward the lower-left:
	procedure set_translation_for_zoom (
		S1	: in type_scale_factor;		-- the scale factor before zoom
		S2	: in type_scale_factor;		-- the scale factor after zoom
		Z1	: in type_vector_gdouble);	-- the zoom center as canvas point

	procedure set_translation_for_zoom (
		S1	: in type_scale_factor;		-- the scale factor before zoom
		S2	: in type_scale_factor;		-- the scale factor after zoom
		M	: in type_vector_model);		-- the zoom center as a real model point


	
	-- In connection with zoom-operations we need the corners of the
	-- bounding-box in canvas coordinates. This composite type serves this
	-- purpose:
	type type_bounding_box_corners is record
		BL, BR, TL, TR : type_vector_gdouble;
	end record;

	-- This function returns the current corners of the bounding-box
	-- in canvas-coordinates. The return depends on the current scale-factor S
	-- and translate-offset:
	function get_bounding_box_corners
		return type_bounding_box_corners;
	


	
-- CONVERSION BETWEEN MODEL AND CANVAS:

	-- Converts the given model distance to
	-- a canvas distance according to the current scale-factor S:
	function to_distance (
		d : in type_distance_model)
		return type_distance_gdouble;

	
	-- Converts the given canvas distance to
	-- a model distance according to the current scale-factor S:
	function to_distance (
		d : in type_distance_gdouble)
		return type_distance_model;

	
	-- Converts a canvas point to a model point
	-- according to the given scale factor, the current
	-- base-offset and the current tranlate-offset.
	-- If a real model point is required, then the position
	-- of the current bonding-box is also taken into account:
	function to_model (
		point	: in type_vector_gdouble;
		scale	: in type_scale_factor;
		real 	: in boolean := false) -- if real model coordinates are required
		return type_vector_model;
	

	-- Converts a model point to a canvas point
	-- according to the given scale factor and the current
	-- base-offset.
	-- If the given model point is real, then the current
	-- tranlate-offset and the position of the current
	-- bounding-box is also taken into account:
	function to_canvas (
		point 	: in type_vector_model;
		scale	: in type_scale_factor;
		real	: in boolean := false) -- if real model coordinates are given
		return type_vector_gdouble;



-- VISIBILTY THRESHOLD:
	
	-- If an object occupies a space that is wider or
	-- higher than this constant, then it will be drawn on the screen:
	visibility_threshold : constant gdouble := 5.0;
	
	-- Returns true if the given area is large enough
	-- to display objects therein:
	function above_visibility_threshold (
		a : in type_area)
		return boolean;


	

	
-- MAIN WINDOW:
	
	main_window	: gtk_window;

	type type_window_size is record
		width, height : positive := 1;
	end record;


	function to_string (
		size : in type_window_size)
		return string;
	

-- GTK-BOXES:
	
	box_h 				: gtk_hbox;
	box_v0				: gtk_vbox;
	box_v1				: gtk_vbox;
	separator			: gtk_separator;

	buttons_table		: gtk_table;
	button_zoom_fit		: gtk_button;
	button_zoom_area	: gtk_button;
	button_move			: gtk_button;
	button_add			: gtk_button;
	button_delete		: gtk_button;
	button_export		: gtk_button;
	
	
	table_coordinates	: gtk_table; -- incl. relative distances
	-- CS rename to coordinates_tabel

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


	
-- COMMAND BUTTONS:

	
	-- This callback procedure is called each time the 
	-- button "zoom fit" is clicked.
	procedure cb_zoom_to_fit (
		button : access gtk_button_record'class);


	-- This composite type provides the ingredients
	-- required to do a zoom-to-area operation:
	type type_zoom_area is record
		-- This flag indicates that the operation is active.
		-- As soon as the operator clicks the "Zoom Area" button,
		-- this flag is set. It is cleared when the operator
		-- releases the right mouse button after she/he has
		-- defined the zoom-area. The zoom-area is a
		-- rectangle:
		active	: boolean := false; 

		-- This is the first corner of the area. It is assigned
		-- when the operator presses the right mouse button
		-- on the canvas to define the start point of the zoom-area:
		k1		: type_vector_model;

		-- This is the second corner of the area. It is assigned
		-- when the operator releases the right mouse button
		-- on the canvas to define end point of the the zoom-area:
		k2		: type_vector_model;

		-- This is the actual area to be zoomed to. It gets fully
		-- specified when the operator releases the right mouse button.
		-- The area will then be passed to the function zoom_to_fit
		-- in order to have the area displayed on the canvas:
		area	: type_area;

		---------------------------------------------------------------
		-- In order to display a rectangle that indicates the
		-- currently selected area we need this stuff.
		-- This is all in the canvas domain and has nothing to
		-- do with the area in the model domain (see above):
		
		-- This flag indicates that the operator has started
		-- the selection. It is cleared when the operator is done
		-- with the selection by releasing the right mouse button:
		started	: boolean := false;

		-- The corners of the selected area:
		l1		: type_vector_gdouble; -- the start point
		l2		: type_vector_gdouble; -- the end point
	end record;

	
	-- This is the instance of the zoom-area:
	zoom_area : type_zoom_area;

	
	-- This is the linewidth of the rectangle that
	-- marks the selected zoom area:
	zoom_area_linewidth : constant gdouble := 2.0;

	
	
	-- This procedure resets the zoom_area (see above)
	-- to its default values. 
	-- Use this procedure to abort a zoom-to-area operation.
	procedure reset_zoom_area;

	
	-- This callback procedure is called each time the 
	-- button "zoom area" is clicked.
	procedure cb_zoom_area (
		button : access gtk_button_record'class);

	
	-- This callback procedure is called each time the 
	-- button "add" is clicked.
	procedure cb_add (
		button : access gtk_button_record'class);

	
	-- This callback procedure is called each time the 
	-- button "delete is clicked.
	procedure cb_delete (
		button : access gtk_button_record'class);

	
	-- This callback procedure is called each time the 
	-- button "move" is clicked.
	procedure cb_move (
		button : access gtk_button_record'class);

	
	-- This callback procedure is called each time the 
	-- button "export" is clicked:
	procedure cb_export (
		button : access gtk_button_record'class);
	

	
-- COORDINATES DISPLAY:
	
	-- Updates the cursor coordinates display
	-- by the current cursor position:
	procedure update_cursor_coordinates;

	
	-- Updates the distances display:
	procedure update_distances_display;


	-- Updates the scale display:
	procedure update_scale_display;
	

	-- Updates the grid display:
	procedure update_grid_display;


	

-- MAIN WINDOW:

	-- This procedure is called when the operator terminates
	-- the demo program by clicking the X in the upper right corner
	-- of the main window:
	procedure cb_terminate (
		window : access gtk_widget_record'class);


	procedure cb_window_focus (
		window : access gtk_window_record'class);



	-- This function is called each time the operator
	-- presses a mouse button.
	function cb_window_button_pressed (
		window	: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;


	-- This function is called each time the operator
	-- hits a key on the keyboard. It does not matter
	-- which widget inside the main window has the focus.
	-- This callback function is at the top of the event-chain.
	-- It is called at first on a key-press event.
	-- If it returns true, then it signals to the 
	-- next widget in the chain downwards to handle the event
	-- further.
	-- The return should depend on the severity of the key.
	-- For example in case of an "emergency-exit" 
	-- the operator hits the ESC key, which causes the abort of
	-- all pending operations. In this case the return would be true
	-- and the event would not be passed on to any widgets down
	-- the chain.
	function cb_window_key_pressed (
		window	: access gtk_widget_record'class;
		event	: gdk_event_key)
		return boolean;

	

-- SCROLLBARS:
	
	-- Updates the limits of the scrollbars.
	-- The argument C1 provides the old corners of the 
	-- bounding-box on the canvas and C2 the new corners:
	procedure update_scrollbar_limits (
		C1, C2 : in type_bounding_box_corners);
	
	
	-- This callback procedure is called each time the size_allocate signal
	-- is emitted by the main window.
	procedure cb_window_size_allocate (
		window		: access gtk_widget_record'class;
		allocation	: gtk_allocation);


	-- This procedure instantiates the main window,
	-- sets the title bar, connects signals, creates
	-- boxes inside the window:
	procedure set_up_main_window;

	
	-- Creates the display for pointer/mouse and cursor position,
	-- distances and angle:
	procedure set_up_coordinates_display;

	
	
-- SCROLLED WINDOW:

	-- This is the scrolled window:
	swin : gtk_scrolled_window;

	-- Inside the scrolled window the canvas exists.
	

	
	-- When the scrolled window is resized, then the canvas can
	-- operate in in several ways. Currently these modes are defined:
	type type_scrolled_window_zoom_mode is (
		-- No zoom. No moving. Just more or less of 
		-- the canvas area is exposed:
		MODE_1_EXPOSE_CANVAS,

		-- Center of visible canvas area remains in the center. 
		-- Around the center more or less of the canvas area is exposed:
		MODE_2_KEEP_CENTER,

		-- The visible area remains fit into the scrolled window.
		MODE_3_ZOOM_FIT);


	zoom_mode : constant type_scrolled_window_zoom_mode := 
		-- MODE_1_EXPOSE_CANVAS;
		-- MODE_2_KEEP_CENTER;
		MODE_3_ZOOM_FIT;

	
	-- In MODE_3_ZOOM_FIT, here the last visible area
	-- immediately before the dimensions of the scrolled window
	-- change, is stored as reference.
	-- In other canvas modi it has no meaning:
	last_visible_area : type_area;


	-- This procedure takes an area and stores it in
	-- the global variable last_visible_area (see above).
	-- Its purpose is to be prepared to fit the area into the 
	-- scrolled window in MODE_3_ZOOM_FIT.
	-- It must be called after operations that result in a
	-- new visibible area. Such operations are:
	-- - scrollbar released
	-- - scroll up/down/right/left
	-- - move cursor
	-- - zoom on cursor
	-- - zoom to fit all 
	-- - zoom to fit area
	-- - zoom on mouse pointer
	-- In in other canvas modi but MODE_3_ZOOM_FIT this
	-- procedure has no meaning:
	procedure backup_visible_area (
		area : in type_area);
	
	
	-- This is the initial size of the scrolled window.
	-- IMPORTANT: The height must be greater than the sum
	-- of the height of all other widgets in the main window !
	-- Otherwise the canvas may freeze and stop emitting signals.
	swin_size_initial : constant type_window_size := (
		width	=> 400,
		height	=> 400);
	
	-- The current size of the scrolled window. It gets updated
	-- in procedure set_up_swin_and_scrollbars and 
	-- in cb_swin_size_allocate. This variable is required
	-- in order to detect size changes of the scrolled window:
	swin_size : type_window_size;

	
	
	
	-- This function calculates the scale factor required to
	-- fit the given area into the current scrolled window.
	-- The scrolled window has an initial size on startup. Later, when
	-- the operator resizes the main window, the scrolled window gets
	-- larger or smaller. This results in a situation depended scale-factor:
	function get_ratio (
		area : in type_area)
		return type_scale_factor;
	
	

	
	-- This callback procedure is called each time the size_allocate signal
	-- is emitted by the scrolled window.
	procedure cb_swin_size_allocate (
		swin		: access gtk_widget_record'class;
		allocation	: gtk_allocation);
	

	
-- SCROLLBARS:
	
	scrollbar_h_adj, scrollbar_v_adj : gtk_adjustment;
	scrollbar_v, scrollbar_h : gtk_scrollbar;

	type type_scroll_direction is (
		SCROLL_UP,
		SCROLL_DOWN,
		SCROLL_RIGHT,
		SCROLL_LEFT);
	
	
	-- This procedure is called whenever the horizontal scrollbar is moved, either
	-- by the operator or by internal calls.
	procedure cb_horizontal_moved (
		scrollbar : access gtk_adjustment_record'class);

	
	-- This procedure is called whenever the vertical scrollbar is moved, either
	-- by the operator or by internal calls.
	procedure cb_vertical_moved (
		scrollbar : access gtk_adjustment_record'class);


	-- This procedure is called when the operator clicks
	-- on the vertical scrollbar:
	function cb_scrollbar_v_pressed (
		bar		: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;
	

	-- This procedure is called when the operator releases
	-- the mouse button after clicking on the vertical scrollbar:
	function cb_scrollbar_v_released (
		bar		: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;


	-- This procedure is called when the operator clicks
	-- on the horizontal scrollbar:
	function cb_scrollbar_h_pressed (
		bar		: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;
	
	
	-- This procedure is called when the operator releases
	-- the mouse button after clicking on the horizontal scrollbar:
	function cb_scrollbar_h_released (
		bar		: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;


	-- This composite type contains the settings
	-- of a scrollbar:
	type type_scrollbar_settings is record
		lower		: gdouble;
		upper		: gdouble;
		value		: gdouble;
		page_size	: gdouble;
	end record;

	-- These are the places where the initial settings of
	-- the scrollbars are stored:
	scrollbar_v_init : type_scrollbar_settings;
	scrollbar_h_init : type_scrollbar_settings;

	-- These are the places where we backup the settings of
	-- the scrollbars:
	scrollbar_h_backup, scrollbar_v_backup : type_scrollbar_settings;

	-- This procedure does a backup of the current settings
	-- of both the horizontal and the vertical scrollbar:
	procedure backup_scrollbar_settings;


	-- This procedure restores the settings of the vertical
	-- and horizontal scrollbar from the backup:
	procedure restore_scrollbar_settings;

	
	-- This procedure creates the scrolled window,
	-- assigns to it the initial size (widht and height),
	-- connects signals.
	-- It also connects the signals emitted by the scrollbars,
	-- sets the behaviour of them:
	procedure set_up_swin_and_scrollbars;


	-- For debugging, these procedures output the settings
	-- of the scrollbars on the console:
	procedure show_adjustments_v;
	procedure show_adjustments_h;

	
	-- Sets the initial scrollbar settings based on
	-- current base-offset and bounding-box:
	procedure set_initial_scrollbar_settings;
	

	
-- CANVAS:

	-- This is the canvas where all the drawing takes place:
	canvas : gtk_drawing_area;


	-- This procedure should be called in order to schedule
	-- a refresh (or redraw) of the canvas:
	procedure refresh (
		canvas	: access gtk_widget_record'class);


	-- This procedure is called when the canvas changes
	-- its size. It is not used currently because the canvas
	-- has a fixed size in this demo program (see below):
	procedure cb_canvas_size_allocate (
		canvas		: access gtk_widget_record'class;
		allocation	: gtk_allocation);



	-- This is the size of the canvas in device pixels.
	-- It is set by procedure compute_canvas_size on system startup:
	canvas_size : type_window_size;

	
	-- This procedure computes the dimensions of the canvas
	-- and assigns them to variable canvas_size_min.
	-- The computation bases on the maximum allowed width
	-- and height of the bounding-box and the maximal
	-- scale-factor.
	-- CS: The computed dimensions may be not sufficient
	-- with very very large screens:
	procedure compute_canvas_size;
	
	
	-- This procedure outputs the current dimensions
	-- of the canvas on the console:
	procedure show_canvas_size;

	
	-- This procedure creates the canvas, assigns to
	-- it a fixed size (variable canvas_size, see above)
	-- and connects signals:
	procedure set_up_canvas;
		

	-- The directions into which the an object can be moved
	-- by means of the cursor keys (arrow keys):
	type type_direction is (DIR_RIGHT, DIR_LEFT, DIR_UP, DIR_DOWN);

	
	-- Shifts the canvas into the given direction
	-- by the given distance:
	procedure shift_canvas (
		direction	: type_direction;
		distance	: type_distance_model);
	
		

	
-- VISIBLE AREA:	

	-- Returns the currently visible area of the model.
	-- The visible area depends the current scale-factor,
	-- base-offset, translate-offset, dimensions of the scrolled window
	-- and the current settings of the scrollbars.
	function get_visible_area (
		canvas	: access gtk_widget_record'class)
		return type_area;

	

	-- This visible area is a global variable.
	-- It is updated by procedure cb_draw_objects.
	-- Some subprograms rely on it, for example those which
	-- move the cursor. For this reason the visible area is
	-- stored in a global variable.
	-- For the future: If the operator searches for a
	-- particular object, then the result of a search could be
	-- a message like "The object is outside the visible
	-- area at position (x/y)."
	visible_area : type_area;



	-- This procedure sets the translate-offset so that
	-- the given area gets centered in the visible area.
	-- The given area can be wider or higher than the visible area:
	procedure center_to_visible_area (
		area : in type_area);

	

-- CURSOR:
	
	-- The cursor is a crosshair that can be moved by the
	-- cursor keys (arrow keys) about the canvas:
	type type_cursor is record
		position	: type_vector_model := origin;

		-- For drawing the cursor:
		linewidth_1	: gdouble := 1.0;
		linewidth_2	: gdouble := 4.0;
		length_1	: gdouble := 20.0;
		length_2	: gdouble := 20.0;
		radius		: gdouble := 25.0;
		
		-- CS: blink, color, ...
	end record;

	
	-- This is the instance of the cursor:
	cursor : type_cursor;



	
	-- This procedure moves the cursor to the given destination:
	procedure move_cursor (
		destination : type_vector_model);


	-- This procedure moves the cursor into the given direction:
	procedure move_cursor (
		direction : type_direction);


	

-- ZOOMING:
	
	-- There are two kinds of zoom-operations:
	type type_zoom_direction is (ZOOM_IN, ZOOM_OUT);

	
	-- Zooms in or out at the current cursor position.
	-- If the direction is ZOOM_IN, then the global scale-factor S
	-- is increased by multplying it with the scale_multiplier.
	-- If direction is ZOOM_OUT then it decreases by dividing
	-- by scale_multiplier:
	procedure zoom_on_cursor (
		direction : in type_zoom_direction);
	

	-- This procedure sets the global scale-factor S and translate-offset T
	-- so that all objects of the given area fit into the scrolled window.
	-- The zoom center is the top-left corner of the given area.
	procedure zoom_to_fit (
		area : in type_area);

	
	-- This procedure sets the global scale-factor S and translate-offset T
	-- so that all objects of bounding-box fit into the scrolled window.
	-- The zoom center is the top-left corner of bounding-box.
	procedure zoom_to_fit_all;

	
	
	-- This callback function is called each time the operator
	-- clicks on the canvas.
	-- It sets the focus on the canvas and moves the cursor
	-- to the place where the operator has clicked the canvas.
	function cb_canvas_button_pressed (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;


	-- This callback function is called each time the operator
	-- releases a mouse button after clicking on the canvas.
	function cb_canvas_button_released (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;

	
	-- This callback function is called each time the operator
	-- moves the pointer (or the mouse) inside the canvas:
	function cb_mouse_moved (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_motion)
		return boolean;


	-- This callback function is called each time the
	-- operator hits a key and if the canvas has the focus:
	function cb_canvas_key_pressed (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_key)
		return boolean;






	-- This function is called each time the mouse wheel is
	-- rolled inside the canvas by the operator:
	function cb_mouse_wheel_rolled (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_scroll)
		return boolean;


	

-- DRAW OPERATIONS:
	
	-- This is a primitive draw operation that draws a line:
	procedure draw_line (
		context	: in cairo_context; -- CS make context global ?
		line	: in type_line;
		pos		: in type_vector_model); -- the position of the complex object


	-- This is a primitive draw operation that draws a circle:
	procedure draw_circle (
		context	: in cairo_context; -- CS make context global ?
		circle	: in type_circle;
		pos		: in type_vector_model); -- the position of the complex object


	
	-- This function is called each time the canvas is to be refreshed:
	function cb_draw_objects (
		canvas	: access gtk_widget_record'class;
		context	: in cairo_context)
		return boolean;
	
end callbacks;

