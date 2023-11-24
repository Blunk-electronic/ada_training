with glib;						use glib;
with gdk.event;					use gdk.event;
with gtk.box;					use gtk.box;
with gtk.separator;				use gtk.separator;
with gtk.combo_box_text;		use gtk.combo_box_text;
with gtk.enums;
with gtk.gentry;				use gtk.gentry;
with gtk.window;				use gtk.window;
with gtk.widget;				use gtk.widget;
with gtk.button;				use gtk.button;
with gtk.label;					use gtk.label;
with gtk.scrolled_window;		use gtk.scrolled_window;
with gtk.adjustment;			use gtk.adjustment;
with gtk.scrollbar;				use gtk.scrollbar;
with gtk.drawing_area;			use gtk.drawing_area;
with cairo;						use cairo;

with geometry;					use geometry;

package callbacks is

-- MAIN WINDOW:
	
	main_window	: gtk_window;

	type type_window_size is record
		width, height : positive := 1;
	end record;


-- BOXES:
	
	h_box_1 : gtk_hbox;
	v_box_1 : gtk_vbox;
	separator_1 : gtk_separator;
	-- separator_2 : gtk_separator;

	
	type type_box_coordinates is record
		main_box				: gtk_vbox;
		title					: gtk_label;
		box_x, box_y			: gtk_hbox;
		label_x, label_y 		: gtk_label;
		position_x, position_y	: gtk_combo_box_text;
	end record;

	-- The box for the pointer coordinates:
	PC : type_box_coordinates;

	-- The box for the cursor coordinates:
	CC : type_box_coordinates;
	

	-- Updates the cursor coordinates display
	-- by the current cursor position:
	procedure update_cursor_coordinates;

	
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
	

	-- Updates the visible area and its center.
	-- Variables modified: visible_area, visible_center:
	-- procedure update_visible_area (
	-- 	canvas	: access gtk_widget_record'class);


	-- CURSOR:
	-- The cursor is a crosshair that can be moved by the
	-- cursor keys (arrow keys) about the canvas:
	type type_cursor is record
		position	: type_point_model := origin;
		linewidth	: gdouble := 1.0;
		size		: gdouble := 20.0; -- the arm-length of the cross
		-- CS other things like a rectangle around
		-- the cross.
		-- CS blink, color, ...
	end record;

	cursor : type_cursor;

	
	-- The directions into which the cursor can be moved
	-- by means of the cursor keys (arrow keys):
	type type_cursor_direction is (CURSOR_RIGHT, CURSOR_LEFT, CURSOR_UP, CURSOR_DOWN);

	
	-- This procedure moves the cursor to the given destination:
	procedure move_cursor (
		destination : type_point_model);


	-- This procedure moves the cursor into the given direction:
	procedure move_cursor (
		direction : type_cursor_direction);

	
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


	-- This function is called each time the canvas is to be refreshed:
	function cb_draw_objects (
		canvas	: access gtk_widget_record'class;
		context	: in cairo_context)
		return boolean;
	
end callbacks;

