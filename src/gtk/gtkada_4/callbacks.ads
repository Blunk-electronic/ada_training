
-- with gtk.main;
-- with gtk.window; 				--use gtk.window;

with gtk.widget;  				--use gtk.widget;
-- with gtk.box;					use gtk.box;
with gtk.button;     			--use gtk.button;
-- with gtk.label;					use gtk.label;
-- with gtk.image;					use gtk.image;
-- with gtk.file_chooser;			use gtk.file_chooser;
-- with gtk.file_chooser_button;	use gtk.file_chooser_button;
-- with gtk.file_filter;			use gtk.file_filter;
-- with gtkada.handlers; 			use gtkada.handlers;
-- with glib.object;
-- with gdk.event;

-- with ada.text_io;			use ada.text_io;


package callbacks is

	procedure terminate_main (self : access gtk.widget.gtk_widget_record'class);

	procedure write_message (self : access gtk.button.gtk_button_record'class);
	
end;
