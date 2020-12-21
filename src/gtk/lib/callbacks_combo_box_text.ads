with gtk.main;					use gtk.main;
with gtk.widget;				use gtk.widget;
with gtk.gentry;				use gtk.gentry;

package callbacks_combo_box_text is

	procedure terminate_main (main_window : access gtk_widget_record'class);
	
	procedure some_text_entered (gentry : access gtk_entry_record'class);
	
end callbacks_combo_box_text;

