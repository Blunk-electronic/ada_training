with gtk.widget;				use gtk.widget;
with gtk.combo_box;				use gtk.combo_box;

package callbacks_combo_box is

	procedure terminate_main (self : access gtk_widget_record'class);
	
	procedure selection_changed (combo : access gtk_combo_box_record'class);
	
end callbacks_combo_box;

