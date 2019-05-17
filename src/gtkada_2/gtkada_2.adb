-- This is a simple ada program, that demonstrates gtkada
-- It draws just a window. The program exits only on CTRL-C.
-- It requires to have package gtkada installed.

-- build with command "gprbuild"
-- clean up with command "gprclean"

with gtk.main;
with gtk.window; 				--use gtk.window;

with gtk.widget;  				--use gtk.widget;
-- with gtk.box;					use gtk.box;
-- with gtk.button;     			use gtk.button;
-- with gtk.label;					use gtk.label;
-- with gtk.image;					use gtk.image;
-- with gtk.file_chooser;			use gtk.file_chooser;
-- with gtk.file_chooser_button;	use gtk.file_chooser_button;
-- with gtk.file_filter;			use gtk.file_filter;
-- with gtkada.handlers; 			use gtkada.handlers;
-- with glib.object;
-- with gdk.event;

with ada.text_io;			use ada.text_io;


procedure gtkada_2 is

	window : gtk.window.gtk_window;

-- 	procedure terminate_main (self : access gtk.widget.gtk_widget_record'class) is
-- 	begin
-- 		put_line("exiting ...");
-- 		gtk.main.main_quit;
-- 	end terminate_main;
	
begin

	put_line ("init gtkada");

	-- initialize gtkada
	gtk.main.init;

	-- create the main window
	gtk.window.gtk_new (window);

	--window.on_destroy (terminate_main'access);
	
	-- show the window
	window.show_all;

	-- All GTK applications must have a Gtk.Main.Main. Control ends here
	-- and waits for an event to occur (like a key press or a mouse event),
	-- until Gtk.Main.Main_Quit is called.
	gtk.main.main;
	
end;
