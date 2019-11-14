-- This is a simple ada program, that demonstrates gtkada
-- It draws a window with some elements in it.

with gtk.main;
with gtk.window; 			use gtk.window;
with gtk.widget;  			use gtk.widget;
with gtk.box;				use gtk.box;
with gtk.button;     		use gtk.button;
with gtk.toolbar; 			use gtk.toolbar;
with gtk.tool_button;		use gtk.tool_button;
with gtk.enums;				use gtk.enums;

with glib.object;			use glib.object;

with ada.text_io;			use ada.text_io;

with callbacks_3;

procedure gtkada_7 is

	window 					: gtk_window;
	box_back				: gtk_box;
	button_up, button_down	: gtk_tool_button;	
	toolbar					: gtk_toolbar;
	
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

	gtk_new (toolbar);
	set_orientation (toolbar, orientation_vertical);
	pack_start (box_back, toolbar);
	
	-- Create a button and place it in the toolbar:
	gtk.tool_button.gtk_new (button_up, label => "UP");
	insert (toolbar, button_up);
	button_up.on_clicked (callbacks_3.write_message_up'access, toolbar);

	-- Create another button and place it in the toolbar:
	gtk.tool_button.gtk_new (button_down, label => "DOWN");
	insert (toolbar, button_down);
	button_down.on_clicked (callbacks_3.write_message_down'access, toolbar);

	window.on_destroy (callbacks_3.terminate_main'access);
	
	window.show_all;

	gtk.main.main;

end;
