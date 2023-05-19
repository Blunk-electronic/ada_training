with ada.text_io;				use ada.text_io;
with gtk.main;					use gtk.main;
with gtk.text_buffer;
with gtk.text_iter;

package body callbacks_text_view_2 is

	procedure terminate_main (main_window : access gtk_widget_record'class) is
	begin
		put_line("exiting ...");
		gtk.main.main_quit;
	end terminate_main;

	
	
end callbacks_text_view_2;

