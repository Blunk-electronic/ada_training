with gtk.widget;				use gtk.widget;
with gtk.button;				use gtk.button;
with gtk.adjustment;			use gtk.adjustment;

package callbacks is

	
	procedure cb_terminate (
		main_window : access gtk_widget_record'class);
	
	-- procedure button_clicked (button : access gtk_button_record'class);

	procedure cb_horizontal_moved (
		scrollbar : access gtk_adjustment_record'class);
	
	procedure cb_vertical_moved (
		scrollbar : access gtk_adjustment_record'class);
	
end callbacks;

