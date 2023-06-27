with glib;						use glib;
with gdk.event;					use gdk.event;
with gtk.widget;				use gtk.widget;
with gtk.button;				use gtk.button;
with gtk.adjustment;			use gtk.adjustment;
with gtk.drawing_area;			use gtk.drawing_area;
with cairo;						use cairo;

package callbacks is

	canvas		: gtk_drawing_area;

	horizontal, vertical : gtk_adjustment;
	
	procedure adjust_canvas_size;
	
	
	procedure refresh (
		canvas	: access gtk_widget_record'class);
	
	
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


	
	function cb_mouse_wheel_rolled (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_scroll)
		return boolean;

	
	function cb_draw (
		canvas	: access gtk_widget_record'class;
		context	: in cairo_context)
		return boolean;
	
end callbacks;

