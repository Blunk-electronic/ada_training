-- This is a simple ada program, that demonstrates gtkada
-- It draws just a window. The program exits on clicking X or on CTRL-C.
-- It requires to have package gtkada installed.

-- build with command "gprbuild"
-- clean up with command "gprclean"

with gtk.main;
with gtk.window;
with gtk.widget;

with ada.text_io;			use ada.text_io;

with callbacks;

procedure gtkada_3 is

	window : gtk.window.gtk_window;

begin
	put_line ("init gtkada");

	gtk.main.init;

	gtk.window.gtk_new (window);
	window.set_title ("Some Title");
	window.set_default_size (800, 600);

	-- On clicking the "X" button in the upper right corner of the window
	-- the program must terminate (by exiting the main loop):
	window.on_destroy (callbacks.terminate_main'access);
	
	window.show_all;

	gtk.main.main;

end;
