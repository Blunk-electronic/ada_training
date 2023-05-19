with gtk.widget;				use gtk.widget;
with gtk.button;				use gtk.button;
with gtk.adjustment;			use gtk.adjustment;

package callbacks is

	
	procedure terminate_main (
		main_window : access gtk_widget_record'class);
	
	-- procedure button_clicked (button : access gtk_button_record'class);

	procedure horizontal_moved (
		scrollbar : access gtk_adjustment_record'class);
	
	procedure vertical_moved (
		scrollbar : access gtk_adjustment_record'class);
	
end callbacks;

