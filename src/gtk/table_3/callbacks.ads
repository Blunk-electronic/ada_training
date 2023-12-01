with gtk.widget;				use gtk.widget;
with gtk.text_view;				use gtk.text_view;
with gtk.text_buffer;			use gtk.text_buffer;

with glib;						use glib;
with gdk;						use gdk;
with gdk.event;					use gdk.event;

package callbacks is

	-- The text views and associated buffers:
	pos_x, pos_y, total				: gtk_text_view;
	pos_x_buf, pos_y_buf, total_buf	: gtk_text_buffer;

	-- The width of the text view shall be wide enough
	-- to fit the greatest numbers:
	pos_field_width_min		: constant gint := 80;
	
	
	-- The coordinates to be displayed in the table:
	type type_distance is delta 0.01 digits 8 range -100_000.00 .. + 100_000.00;
	x, y : type_distance := 1.0;

	
	-- This procedure updates the values shown in the table:
	procedure update_table_content;
	

	-- This procedure is called when the operator
	-- terminates the program:
	procedure terminate_main (
		window : access gtk_widget_record'class);


	
	-- This function is called each time the operator hits
	-- a key. It evaluates the key and decides whether the
	-- x- or y-coordinate is to be changed:
	function cb_key_pressed (
		window	: access gtk_widget_record'class;
		event	: gdk_event_key)
		return boolean;

	
end callbacks;

