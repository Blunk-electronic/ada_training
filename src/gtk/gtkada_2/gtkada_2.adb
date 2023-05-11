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

	-- This is a so called "callback" procedure. It is called when the 
	-- window emits the destroy-signal.
	-- This procedure terminates the main gtk loop:
	procedure terminate_main (
		self : access gtk.widget.gtk_widget_record'class) 
	is begin
		put_line("exiting ...");

		-- terminate the main gtk loop:
		gtk.main.main_quit;
	end;

	
	window : gtk.window.gtk_window;

begin
	-- THIS IS ALL PREPARATION STUFF:
	
	put_line ("init gtkada");

	-- initialize gtkada
	gtk.main.init;

	-- create the main window
	gtk.window.gtk_new (window);

	-- On clicking the "X" in the upper right corner of the window
	-- the program shall terminate completely.
	-- Monitoring of signals emitted by the window is required.
	-- So here we connect the destroy-signal with a so called
	-- "callback" procedure. If the window emits the destroy-signal,
	-- then the callback procedure terminate_main is called:
	window.on_destroy (terminate_main'unrestricted_access);

	-- NOTE: The parameter of window.on_destroy is a Cb_Gtk_Widget_Void type.
	-- See package gtk-widget:
	-- type Cb_Gtk_Widget_Void is not null access procedure (Self : access Gtk_Widget_Record'Class);
	
	-- show the window
	window.show_all;

	-- PREPARATION END ------------------------

	
	-- All GTK applications must have a Gtk.Main.Main.
	gtk.main.main;
end;
