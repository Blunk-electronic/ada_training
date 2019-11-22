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
-- with gtk.bin;				use gtk.bin;

with glib;					use glib;
with glib.object;
with cairo;					use cairo;
with cairo.pattern;			use cairo.pattern;
with gtkada.canvas_view;	use gtkada.canvas_view;
with gtkada.style;     		use gtkada.style;

with pango.layout;			use pango.layout;

with ada.containers;		use ada.containers;
with ada.containers.doubly_linked_lists;

with ada.text_io;			use ada.text_io;

with callbacks_3;

procedure gtkada_8 is

	window 					: gtk_window;
	box_back				: gtk_box;
	box_left, box_right		: gtk_box;
	box_console				: gtk_box;
	box_drawing				: gtk_box;
	button_up, button_down	: gtk_tool_button;	
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
		add (box_back, box_left);

		-- right box
		gtk_new_vbox (box_right);
		set_spacing (box_right, 10);
		add (box_back, box_right);

		-- toolbar on the left
		gtk_new (toolbar);
		set_orientation (toolbar, orientation_vertical);
		pack_start (box_left, toolbar);
		
		-- Create a button and place it in the toolbar:
		gtk.tool_button.gtk_new (button_up, label => "UP");
		insert (toolbar, button_up);
		button_up.on_clicked (callbacks_3.write_message_up'access, toolbar);

		-- Create another button and place it in the toolbar:
		gtk.tool_button.gtk_new (button_down, label => "DOWN");
		insert (toolbar, button_down);
		button_down.on_clicked (callbacks_3.write_message_down'access, toolbar);


		-- box for console on the right top
		gtk_new_vbox (box_console);
		set_spacing (box_console, 10);
		add (box_right, box_console);

		-- a simple text entry
		gtk_new (console);
		set_text (console, "cmd");
		pack_start (box_console, console);
		console.on_activate (callbacks_3.echo_command_simple'access); -- on hitting enter

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
	
	-- ITEM
-- 	item : canvas_item;

-- 	type type_item_abstract is interface;
-- 
-- 	type type_item_pointer is access all type_item_abstract'class;
-- -- 	item : type_item_pointer;
-- 
-- 	package pac_items is new ada.containers.doubly_linked_lists (type_item_pointer);
-- 
-- 	type type_model is new canvas_model_record with record
-- 		items : pac_items.list;
-- 		--  items are sorted: lowest items first (minimal z-layer)
-- 	end record;


	
	-- pointers to model and view
	model : gtkada.canvas_view.list_canvas_model;
	view : gtkada.canvas_view.canvas_view;


	
	model_rec : model_rectangle := (gdouble (0), gdouble (0), gdouble (20), gdouble (20));
	context : draw_context;

	
begin
	init;

	-- model
	model := new list_canvas_model_record;
	initialize (model);
	
	-- view
	gtk_new (view, model);
	initialize (view, model);
-- 	unref (model);

	-- context
	context := build_context (view);

-- 	set_grid_size (view);
-- 	draw_internal (view, context, model_rec);

-- 	item := new canvas_item_record;
	
	-- 	draw (dummy, cr);
	
	add (scrolled, view);
	
	window.on_destroy (callbacks_3.terminate_main'access);
	
	window.show_all;

	gtk.main.main;

end;
