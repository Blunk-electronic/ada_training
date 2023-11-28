-- This is a simple ada program, that demonstrates gtkada
-- It shows a window with a text view.
-- It requires to have package gtkada installed.

-- build with command "gprbuild"
-- clean up with command "gprclean"

with gtk.main;					use gtk.main;
with gtk.window;				use gtk.window;
with gtk.box;					use gtk.box;
with gtk.text_view;				use gtk.text_view;
with gtk.button;				use gtk.button;

with ada.text_io;				use ada.text_io;

with callbacks_text_view;


procedure text_view_1 is

	window		: gtk.window.gtk_window;
	box			: gtk_vbox;
	button		: gtk_button;

begin
	init;

	gtk_new (window);
	window.set_title ("Text View Demo");
	window.set_default_size (300, 100);
	window.on_destroy (callbacks_text_view.terminate_main'access);

	gtk_new_vbox (box);
	window.add (box);


	
	-- Create the text view.
	-- NOTE: The variable my_text_view is declared in callbacks_text_view
	-- so that it is visible from here and from the sub-programs 
	-- in callbacks_text_view. This way the procedure "button_clicked"
	-- (see below) can read the text that is shown in the text_view.
	gtk_new (callbacks_text_view.my_text_view);

	-- callbacks_text_view.my_text_view.set_editable (false);
	
	-- Put the text view in the box:
	pack_start (box, callbacks_text_view.my_text_view);


	-- Create a button "apply" and put it in the box below the
	-- text view.
	-- On clicking the button, the text, typed in the text view,
	-- is output on the console.
	gtk_new (button, "Apply");
	pack_start (box, button);
	button.on_clicked (callbacks_text_view.button_clicked'access);
	
	-- show the window
	window.show_all;

	-- All GTK applications must have a Gtk.Main.Main. Control ends here
	-- and waits for an event to occur (like a key press or a mouse event),
	-- until Gtk.Main.Main_Quit is called.
	gtk.main.main;
	
end text_view_1;

