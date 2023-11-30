with ada.text_io;				use ada.text_io;
with gtk.main;					use gtk.main;

package body callbacks is

	procedure terminate_main (main_window : access gtk_widget_record'class) is
	begin
		put_line("exiting ...");
		gtk.main.main_quit;
	end terminate_main;
	
end callbacks;

