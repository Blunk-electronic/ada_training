with gtk.main;
with gtk.window; 

with gtk.widget;

with ada.text_io;			use ada.text_io;

package body callbacks_combo_box is

	procedure terminate_main (self : access gtk.widget.gtk_widget_record'class) is
	begin
		put_line("exiting ...");
		gtk.main.main_quit;
	end terminate_main;

end callbacks_combo_box;
