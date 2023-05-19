with gtk.widget;				use gtk.widget;
with gtk.button;				use gtk.button;


package callbacks is

	
	procedure terminate_main (
		main_window : access gtk_widget_record'class);
	
	-- procedure button_clicked (button : access gtk_button_record'class);
	
end callbacks;

