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
with gtk.text_buffer;			use gtk.text_buffer;

with ada.text_io;				use ada.text_io;

with callbacks_text_view;		use callbacks_text_view;


procedure text_view_2 is

	window		: gtk.window.gtk_window;
	box			: gtk_vbox;
	button		: gtk_button;

	buffer		: gtk_text_buffer;
begin
	init;

	gtk_new (window);
	window.set_title ("Text View Demo 2");
	window.set_default_size (300, 100);
	window.on_destroy (callbacks_text_view.terminate_main'access);

	gtk_new_vbox (box);
	window.add (box);
	
	-- Create the text view:
	gtk_new (callbacks_text_view.my_text_view);

	-- Create a new text buffer with a fixed text inside:
	gtk_new (buffer);
	buffer.set_text ("Hello");
	my_text_view.set_buffer (buffer);
	--my_text_view.set_editable (false);
	
	-- Put the text view in the box:
	pack_start (box, my_text_view);


	-- Create a button "apply" and put it in the box below the
	-- text view.
	-- On clicking the button, the text, typed in the text view,
	-- is output on the console.
	gtk_new (button, "Apply");
	pack_start (box, button);
	button.on_clicked (button_clicked'access);
	
	-- show the window
	window.show_all;

	-- All GTK applications must have a Gtk.Main.Main. Control ends here
	-- and waits for an event to occur (like a key press or a mouse event),
	-- until Gtk.Main.Main_Quit is called.
	gtk.main.main;
	
end text_view_2;

