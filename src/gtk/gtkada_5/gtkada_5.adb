-- This is a simple ada program, that demonstrates gtkada
-- It draws a window with some elements in it.

with gtk.main;
with gtk.window; 			use gtk.window;
with gtk.widget;  			use gtk.widget;
with gtk.box;				use gtk.box;
with gtk.button;     		use gtk.button;

with ada.text_io;			use ada.text_io;

with callbacks_3;

procedure gtkada_5 is

	window 					: gtk_window;
	box_back, box_A, box_B	: gtk_box;
	button_on, button_off	: gtk_button;	
	
begin
	gtk.main.init;

	gtk_new (window);
	window.set_title ("Some Title");
	window.set_default_size (800, 600);

	-- Create and place a horizontal background box.
	-- Objects placed there will be arraged horizontally.
	gtk_new_hbox (box_back);
	set_spacing (box_back, 100); -- spacing BETWEEN elements inside the box
	add (window, box_back);

	-- Create box A inside box_back with extra space AROUND it.
	gtk_new_vbox (box_A);
	pack_start (box_back, box_A, padding => 50);

	-- Create another box inside box_back with extra space AROUND it.
	gtk_new_vbox (box_B);
	pack_start (box_back, box_B, padding => 50);	

	
	-- Create buttons with extra space AROUND them and place them in the boxes:
	gtk_new (button_off, "POWER OFF");
	pack_start (box_A, button_off, padding => 100);

	gtk_new (button_on, "POWER ON");
	pack_start (box_B, button_on, padding => 200);

	
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
