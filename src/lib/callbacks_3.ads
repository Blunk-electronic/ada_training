with gtk.widget;  		--use gtk.widget;
with gtk.button;     	--use gtk.button;
with glib.object;		-- use glib.object;
with gtk.gentry;
-- with gtk.combo_box;

package callbacks_3 is

	procedure terminate_main (self : access gtk.widget.gtk_widget_record'class);

	procedure write_message_off (self : access gtk.button.gtk_button_record'class);
	procedure write_message_on (self : access gtk.button.gtk_button_record'class);

	procedure write_message_up (self : access glib.object.gobject_record'class);
	procedure write_message_down (self : access glib.object.gobject_record'class);	

	procedure echo_command_simple (self : access gtk.gentry.gtk_entry_record'class);
-- 	procedure echo_command_advanced (self : access gtk.combo_box.gtk_combo_box_record'class);	
end;
