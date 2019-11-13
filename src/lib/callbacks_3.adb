with gtk.widget;
with gtk.main;
with gtk.window;
with gtk.button;

with ada.text_io;			use ada.text_io;

package body callbacks_3 is

	procedure terminate_main (self : access gtk.widget.gtk_widget_record'class) is
	begin
		put_line("exiting ...");
		gtk.main.main_quit;
	end;

	procedure write_message_off (self : access gtk.button.gtk_button_record'class) is
	begin
		put_line("The machine is being shutdown ...");
		
		-- do things requried to shut down the machine ...
	end;

	procedure write_message_on (self : access gtk.button.gtk_button_record'class) is
	begin
		put_line("The machine is being powered up ...");
		
		-- do things requried to power up the machine ...
	end;

	
end;
