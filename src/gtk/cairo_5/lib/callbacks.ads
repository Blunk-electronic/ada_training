with glib;						use glib;
with gdk.event;					use gdk.event;
with gtk.window;				use gtk.window;
with gtk.widget;				use gtk.widget;
with gtk.button;				use gtk.button;
with gtk.scrolled_window;		use gtk.scrolled_window;
with gtk.adjustment;			use gtk.adjustment;
with gtk.scrollbar;				use gtk.scrollbar;
with gtk.drawing_area;			use gtk.drawing_area;
with cairo;						use cairo;

package callbacks is

-- MAIN WINDOW:
	
	main_window	: gtk_window;

	procedure cb_terminate (
		main_window : access gtk_widget_record'class);


	procedure cb_size_allocate_main (
		window		: access gtk_widget_record'class;
		allocation	: gtk_allocation);

	
	procedure set_up_main_window;


	
-- SCROLLED WINDOW:
	
	swin		: gtk_scrolled_window;

	function cb_button_pressed_win (
		swin	: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;


	
-- SCROLLBARS:
	
	scrollbar_h_adj, scrollbar_v_adj : gtk_adjustment;
	scrollbar_v : gtk_scrollbar;

	UM, LM : gdouble := 0.0;
	
	procedure compute_LM_UM;
	

	procedure cb_horizontal_moved (
		scrollbar : access gtk_adjustment_record'class);

	
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

	
	type type_scrollbar_settings is record
		lower		: gdouble;
		upper		: gdouble;
		value		: gdouble;
		page_size	: gdouble;
	end record;

	scrollbar_v_init : type_scrollbar_settings;

	procedure set_up_scrollbars;

	procedure show_adjustments;

	procedure prepare_initial_scrollbar_settings;
	
	procedure apply_initial_scrollbar_settings;
	

	
-- CANVAS:
	
	canvas		: gtk_drawing_area;

	procedure refresh (
		canvas	: access gtk_widget_record'class);


	procedure cb_size_allocate (
		canvas		: access gtk_widget_record'class;
		allocation	: gtk_allocation);

	
	
	procedure show_canvas_size;
	
	procedure set_up_canvas;
		


	

	type type_zoom is (ZOOM_IN, ZOOM_OUT);

	
	
	
	


	
	function cb_button_pressed (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;

	
	function cb_mouse_moved (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_motion)
		return boolean;

	
	function cb_key_pressed (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_key)
		return boolean;


	procedure cb_realized (
		canvas	: access gtk_widget_record'class);
	
	
	function cb_mouse_wheel_rolled (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_scroll)
		return boolean;

	
	function cb_draw (
		canvas	: access gtk_widget_record'class;
		context	: in cairo_context)
		return boolean;
	
end callbacks;

