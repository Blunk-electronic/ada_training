-- This is a simple ada program, that demonstrates gtkada
-- It draws just a window. The program exits only on CTRL-C.
-- It requires to have package gtkada installed.

-- build with command "gprbuild"
-- clean up with command "gprclean"

with gtk.main;
with gtk.window;

with ada.text_io;			use ada.text_io;

procedure gtkada_1 is

	window : gtk.window.gtk_window;
	
begin
	-- THIS IS ALL PREPARATION STUFF:
	
	put_line ("init gtkada");

	-- initialize gtkada
	gtk.main.init;

	-- create the main window
	gtk.window.gtk_new (window);

	-- show the window
	window.show_all;

	-- PREPARATION END ------------------------


	
	-- Now the actual drawing of the window starts in the gtk main loop.
	-- The loop goes on until CTRL-C is pressed.
	-- There is no other way to terminate the loop because no
	-- monitoring of any signals takes place. Hence the 
	-- "destroy signal" (emitted by the window) is not evaluated in this simple
	-- example.

	-- NOTE: Clicking the "X" in the upper right corner of the window causes
	-- the window do disappear, but the program gtkada_1 keeps running until
	-- CTRL-C is pressed.
	
	-- All GTK applications must have a Gtk.Main.Main.
	gtk.main.main;
	
end;
