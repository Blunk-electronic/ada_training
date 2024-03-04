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

with demo_buttons;
with geometry_1;				use geometry_1;
with geometry_2;				use geometry_2;
with demo_objects;				use demo_objects;
with demo_window_dimensions;	use demo_window_dimensions;
with demo_canvas;				use demo_canvas;
with demo_conversions;			use demo_conversions;
with demo_main_window;			use demo_main_window;
with demo_coordinates_display;


package callbacks is


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
		M	: in type_vector_model);	-- the zoom center as a real model point

	


	
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


	
	
-- SCROLLED WINDOW:

	
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


	
	-- This procedure creates the scrolled window,
	-- assigns to it the initial size (widht and height),
	-- connects signals.
	-- It also connects the signals emitted by the scrollbars,
	-- sets the behaviour of them:
	procedure set_up_swin_and_scrollbars;


	


	
-- CANVAS:

	-- This procedure is called when the canvas changes
	-- its size. It is not used currently because the canvas
	-- has a fixed size in this demo program (see below):
	procedure cb_canvas_size_allocate (
		canvas		: access gtk_widget_record'class;
		allocation	: gtk_allocation);

	
	-- This procedure creates the canvas, assigns to
	-- it a fixed size and connects signals:
	procedure set_up_canvas;
		
	

	
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

