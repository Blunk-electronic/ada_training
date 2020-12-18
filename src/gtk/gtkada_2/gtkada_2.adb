-- This is a simple ada program, that demonstrates gtkada
-- It draws just a window. The program exits on clicking X or on CTRL-C.
-- It requires to have package gtkada installed.

-- build with command "gprbuild"
-- clean up with command "gprclean"

with gtk.main;
with gtk.window;
with gtk.widget;

with ada.text_io;			use ada.text_io;

procedure gtkada_2 is

	procedure terminate_main (self : access gtk.widget.gtk_widget_record'class) is 
	begin
		put_line("exiting ...");
		gtk.main.main_quit;
	end;
	
	window : gtk.window.gtk_window;

begin
	put_line ("init gtkada");

	-- initialize gtkada
	gtk.main.init;

	-- create the main window
	gtk.window.gtk_new (window);

	-- On clicking the "X" button in the upper right corner of the window
	-- the program must terminate (by exiting the main loop):
	window.on_destroy (terminate_main'unrestricted_access);
	
	-- show the window
	window.show_all;

	-- All GTK applications must have a Gtk.Main.Main. Control ends here
	-- and waits for an event to occur (like a key press or a mouse event),
	-- until Gtk.Main.Main_Quit is called.
	gtk.main.main;
end;
