with ada.text_io;				use ada.text_io;
with gtk.main;					use gtk.main;
with gtk.text_buffer;
with gtk.text_iter;

package body callbacks_text_view is

	procedure terminate_main (main_window : access gtk_widget_record'class) is
	begin
		put_line("exiting ...");
		gtk.main.main_quit;
	end terminate_main;

	
	procedure button_clicked (button : access gtk_button_record'class) is
		use gtk.text_buffer;
		use gtk.text_iter;

		-- Get the text buffer of the text view my_text_view:
		text_buffer : constant gtk_text_buffer := get_buffer (my_text_view);

		-- Variables for first and last character in text view:
		lower_bound, upper_bound : gtk_text_iter;
	begin
		put_line ("button apply clicked");

		get_bounds (text_buffer, lower_bound, upper_bound);

		put_line ("content: " & get_text (text_buffer, lower_bound, upper_bound));

	end button_clicked;
	
end callbacks_text_view;

