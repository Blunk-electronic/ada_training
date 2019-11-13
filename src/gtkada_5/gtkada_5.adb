-- This is a simple ada program, that demonstrates gtkada
-- It draws a window with some elements in it.

with gtk.main;
with gtk.window; 				use gtk.window;
with gtk.widget;  				use gtk.widget;
with gtk.box;					use gtk.box;
with gtk.button;     			use gtk.button;
-- with gtk.label;					use gtk.label;
-- with gtk.image;					use gtk.image;
-- with gtk.file_chooser;			use gtk.file_chooser;
-- with gtk.file_chooser_button;	use gtk.file_chooser_button;
-- with gtk.file_filter;			use gtk.file_filter;
-- with gtkada.handlers; 			use gtkada.handlers;
-- with glib.object;
-- with gdk.event;

with ada.text_io;			use ada.text_io;

with callbacks_3;

procedure gtkada_5 is

	window 	: gtk_window;
	box_back, box_A, box_B : gtk_box;
	button_on, button_off	: gtk_button;	
	
begin
	gtk.main.init;

	gtk_new (window);
	window.set_title ("Some Title");
	window.set_default_size (800, 600);

	-- Create and place a horizontal background box.
	-- Objects placed there will be arraged horizontally.
	gtk_new_hbox (box_back);
	add (window, box_back);

	-- Create a box inside box_back.
	gtk_new_vbox (box_A);
	add (box_back, box_A);

	-- Create another box inside box_back
	gtk_new_vbox (box_B);
	add (box_back, box_B);

	
	-- Create buttons and place them in the boxes:
	gtk_new (button_off, "POWER OFF");
	pack_start (box_A, button_off);

	gtk_new (button_on, "POWER ON");
	pack_start (box_B, button_on);

	
	-- Now we connect the events issued by the window
	-- with some subprograms that do something:
	
	button_on.on_clicked  (callbacks_3.write_message_on'access);
	button_off.on_clicked (callbacks_3.write_message_off'access);	
	
	-- On clicking the "X" button in the upper right corner of the window
	-- the program must terminate (by exiting the main loop):
	window.on_destroy (callbacks_3.terminate_main'access);
	
	window.show_all;

	gtk.main.main;

end;
