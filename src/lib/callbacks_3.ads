with gtk.widget;  		--use gtk.widget;
with gtk.button;     	--use gtk.button;
with glib.object;		-- use glib.object;

-- with gtk.label;					use gtk.label;
-- with gtk.image;					use gtk.image;
-- with gtk.file_chooser;			use gtk.file_chooser;
-- with gtk.file_chooser_button;	use gtk.file_chooser_button;
-- with gtk.file_filter;			use gtk.file_filter;
-- with gtkada.handlers; 			use gtkada.handlers;
-- with glib.object;
-- with gdk.event;

-- with ada.text_io;			use ada.text_io;


package callbacks_3 is

	procedure terminate_main (self : access gtk.widget.gtk_widget_record'class);

	procedure write_message_off (self : access gtk.button.gtk_button_record'class);
	procedure write_message_on (self : access gtk.button.gtk_button_record'class);

	procedure write_message_up (self : access glib.object.gobject_record'class);
	procedure write_message_down (self : access glib.object.gobject_record'class);	
end;
