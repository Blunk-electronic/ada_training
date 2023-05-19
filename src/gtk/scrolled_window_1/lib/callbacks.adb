with ada.text_io;				use ada.text_io;
with ada.calendar;				use ada.calendar;
with ada.calendar.formatting;	use ada.calendar.formatting;

with gtk.main;					use gtk.main;


package body callbacks is

	procedure terminate_main (
		main_window : access gtk_widget_record'class) 
	is begin
		put_line ("exiting ...");
		gtk.main.main_quit;
	end terminate_main;


	procedure horizontal_moved (
		scrollbar : access gtk_adjustment_record'class)
	is begin
		put_line ("horizontal moved " & image (clock));
	end horizontal_moved;

	
	procedure vertical_moved (
		scrollbar : access gtk_adjustment_record'class)
	is begin
		put_line ("vertical moved " & image (clock));
	end vertical_moved;

	
	
end callbacks;

