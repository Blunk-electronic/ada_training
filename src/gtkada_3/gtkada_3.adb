-- This is a simple ada program, that demonstrates gtkada
-- It draws just a window. The program exits on clicking X or on CTRL-C.
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

with callbacks;

procedure gtkada_3 is

	window : gtk.window.gtk_window;

begin
	put_line ("init gtkada");

	gtk.main.init;

	gtk.window.gtk_new (window);

	window.on_destroy (callbacks.terminate_main'access);

	
	window.show_all;

	gtk.main.main;

end;
