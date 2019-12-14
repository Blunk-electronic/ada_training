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
with gtk.gentry;			use gtk.gentry;
with gtk.combo_box_text;	use gtk.combo_box_text;
with gtk.frame;				use gtk.frame;
with gtk.scrolled_window;	use gtk.scrolled_window;
with gtk.bin;				use gtk.bin;
with gtk.adjustment;		use gtk.adjustment;
-- with gtk.handlers;			use gtk.handlers;
-- with gtkada.handlers;		use gtkada.handlers;
with glib.properties.creation;	use glib.properties.creation;
with glib;					use glib;
with glib.values;			use glib.values;
with glib.object;			use glib.object;
with cairo;					use cairo;
with cairo.pattern;			use cairo.pattern;
with cairo.image_surface;	use cairo.image_surface;
-- with gtkada.canvas_view;	use gtkada.canvas_view;
-- with gtkada.canvas_view.views;	use gtkada.canvas_view.views;
-- with gtkada.style;     		use gtkada.style;

-- with pango.layout;			use pango.layout;

with ada.containers;		use ada.containers;
with ada.containers.doubly_linked_lists;

with ada.text_io;			use ada.text_io;

with callbacks_4;			use callbacks_4;
with canvas_test;			use canvas_test;

procedure gtkada_9 is

	window 					: gtk_window;
	box_back				: gtk_box;
	box_left, box_right		: gtk_box;
	box_console				: gtk_box;
	box_drawing				: gtk_box;
	
	button_zoom_to_fit					: gtk_tool_button;
	button_zoom_in, button_zoom_out		: gtk_tool_button;
	button_move_right, button_move_left	: gtk_tool_button;
	button_delete						: gtk_tool_button;
	
	toolbar					: gtk_toolbar;
	console					: gtk_entry;
	frame					: gtk_frame;
	scrolled				: gtk_scrolled_window;
	
	procedure init is begin
		gtk.main.init;

		gtk_new (window);
		window.set_title ("Some Title");
		window.set_default_size (800, 600);

		-- background box
		gtk_new_hbox (box_back);
		set_spacing (box_back, 10);
		add (window, box_back);

		-- left box
		gtk_new_hbox (box_left);
		set_spacing (box_left, 10);
		pack_start (box_back, box_left, expand => false);

		-- right box
		gtk_new_vbox (box_right);
		set_spacing (box_right, 10);
		add (box_back, box_right);

		-- toolbar on the left
		gtk_new (toolbar);
		set_orientation (toolbar, orientation_vertical);
		pack_start (box_left, toolbar, expand => false);
		
		-- Create a button and place it in the toolbar:
-- 		gtk.tool_button.gtk_new (button_up, label => "UP");
-- 		insert (toolbar, button_up);
-- 		button_up.on_clicked (callbacks_4.write_message_up'access, toolbar);

		-- Create another button and place it in the toolbar:
		gtk.tool_button.gtk_new (button_zoom_to_fit, label => "FIT");
		insert (toolbar, button_zoom_to_fit);
		button_zoom_to_fit.on_clicked (callbacks_4.zoom_to_fit'access, toolbar);

		-- Create a button and place it in the toolbar:
		gtk.tool_button.gtk_new (button_zoom_in, label => "IN");
		insert (toolbar, button_zoom_in);
		button_zoom_in.on_clicked (callbacks_4.zoom_in'access, toolbar);

		-- Create another button and place it in the toolbar:
		gtk.tool_button.gtk_new (button_zoom_out, label => "OUT");
		insert (toolbar, button_zoom_out);
		button_zoom_out.on_clicked (callbacks_4.zoom_out'access, toolbar);

		-- Create another button and place it in the toolbar:
		gtk.tool_button.gtk_new (button_move_right, label => "MOVE RIGHT");
		insert (toolbar, button_move_right);
		button_move_right.on_clicked (callbacks_4.move_right'access, toolbar);
		
		gtk.tool_button.gtk_new (button_move_left, label => "MOVE LEFT");
		insert (toolbar, button_move_left);
		button_move_left.on_clicked (callbacks_4.move_left'access, toolbar);

		gtk.tool_button.gtk_new (button_delete, label => "DELETE");
		insert (toolbar, button_delete);
		button_delete.on_clicked (callbacks_4.delete'access, toolbar);

		
		-- box for console on the right top
		gtk_new_vbox (box_console);
		set_spacing (box_console, 10);
		pack_start (box_right, box_console, expand => false);

		-- a simple text entry
		gtk_new (console);
		set_text (console, "cmd");
		pack_start (box_console, console, expand => false);
		console.on_activate (callbacks_4.echo_command_simple'access); -- on hitting enter

		-- drawing area on the right bottom
		gtk_new_hbox (box_drawing);
		set_spacing (box_drawing, 10);
		add (box_right, box_drawing);

		gtk_new (frame);
		pack_start (box_drawing, frame);

		gtk_new (scrolled);
		set_policy (scrolled, policy_automatic, policy_automatic);
		add (frame, scrolled);

	end;


	model : type_model_ptr;
	item : type_item_ptr;
	
begin
	init;

	-- model
	gtk_new (model);
	initialize (model);
	
	-- canvas
	gtk_new (canvas, model);
	add (scrolled, canvas);
	
	item := new type_item;
	
	set_position (item, p1);
-- 	put_line (to_string (position (item)));
	add (model, item);

-- 	canvas.set_scale (0.4);
	
	scale_to_fit (canvas);
	
	window.on_destroy (callbacks_4.terminate_main'access);

	window.show_all;
	gtk.main.main;
end;
