with gdk.event;					use gdk.event;
with gtk.widget;				use gtk.widget;
with gtk.window;				use gtk.window;
with gtk.scrolled_window;		use gtk.scrolled_window;
with gtk.button;				use gtk.button;
with gtk.adjustment;			use gtk.adjustment;
with gtk.drawing_area;			use gtk.drawing_area;
with cairo;						use cairo;

package callbacks is

	window		: gtk_window;
	swin		: gtk_scrolled_window;
	canvas		: gtk_drawing_area;

	
	procedure cb_terminate (
		main_window : access gtk_widget_record'class);
	

	procedure cb_horizontal_moved (
		scrollbar : access gtk_adjustment_record'class);

	
	procedure cb_vertical_moved (
		scrollbar : access gtk_adjustment_record'class);

	
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


	procedure cb_size_allocate (
		canvas		: access gtk_widget_record'class;
		allocation	: gtk_allocation);

	
	function cb_mouse_wheel_rolled (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_scroll)
		return boolean;

	
	function cb_draw (
		canvas	: access gtk_widget_record'class;
		context	: in cairo_context)
		return boolean;
	
end callbacks;

