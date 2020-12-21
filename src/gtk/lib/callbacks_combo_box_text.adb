with ada.text_io;				use ada.text_io;

package body callbacks_combo_box_text is

	procedure terminate_main (main_window : access gtk_widget_record'class) is
	begin
		put_line("exiting ...");
		gtk.main.main_quit;
	end terminate_main;

	procedure some_text_entered (gentry : access gtk_entry_record'class) is
		text : constant string := get_text (gentry);
	begin
		put_line ("entered text: " & text);
	end some_text_entered;
		
end callbacks_combo_box_text;
