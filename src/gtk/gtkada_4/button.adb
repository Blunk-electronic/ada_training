-- This is a simple ada program, that demonstrates a button.

with gtk.main;
with gtk.window; 				--use gtk.window;
with gtk.widget;  				--use gtk.widget;
with gtk.box;					--use gtk.box;
with gtk.button;     			--use gtk.button;

with ada.text_io;			use ada.text_io;

with callbacks;

procedure button is

	window 	: gtk.window.gtk_window;
	box		: gtk.box.gtk_box;
	button	: gtk.button.gtk_button;	
	
begin
	put_line ("init gtkada");

	gtk.main.init;

	gtk.window.gtk_new (window);
	window.set_title ("Some Title");
	window.set_default_size (800, 600);

	-- create and place a background box
	gtk.box.gtk_new_vbox (box);
	gtk.window.add (window, box);

	-- Create a button labeled with "POWER OFF" and place it in box.
	gtk.button.gtk_new (button, "POWER OFF");
	gtk.box.pack_start (box, button);

	-- Now we connect the events issued by the window
	-- with some subprograms that do something:
	
	-- On clicking the button "POWER OFF" write a message:
	button.on_clicked (callbacks.write_message'access);
	
	-- On clicking the "X" button in the upper right corner of the window
	-- the program must terminate (by exiting the main loop):
	window.on_destroy (callbacks.terminate_main'access);
	
	window.show_all;

	gtk.main.main;

end button;
