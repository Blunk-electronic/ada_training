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

	type type_item is tagged record
		x, y : gdouble;
	end record;

	type type_item_pointer is access all type_item'class;
	item : type_item_pointer;

	package pac_items is new ada.containers.doubly_linked_lists (type_item_pointer);


	
	type type_model is new glib.object.gobject_record with record
		items : pac_items.list;
	end record;

	type type_model_pointer is access all type_model;
	model : type_model_pointer; -- pointer to the model


	
	type type_view is new gtk.widget.gtk_widget_record with record
		model : type_model_pointer;
	end record;

	type type_view_pointer is access type_view;
		
	view : type_view_pointer; -- pointer to a view


	
	model_rec : model_rectangle := (gdouble (0), gdouble (0), gdouble (20), gdouble (20));
	context : draw_context;


	
	procedure init_model (
		self : not null access type_model'class) is
		use glib.object;
	begin
		if not self.is_created then
			g_new (self, model_get_type);
		end if;
      --  ??? When destroyed, should unreferenced Self.Layout
	end;

	procedure set_model (
		self  : not null access type_view'class;
		model : access type_model'class)
	is
	begin
		if self.model = type_model_pointer (model) then
			return;
		end if;

-- 		if self.model /= null then
-- 			disconnect (self.model, self.id_layout_changed);
-- 			disconnect (self.model, self.id_item_contents_changed);
-- 			disconnect (self.model, self.id_selection_changed);
-- 			disconnect (self.model, self.id_item_destroyed);
-- 			unref (self.model);
-- 		end if;
-- 
-- 		self.model := canvas_model (model);
-- 
-- 		if self.model /= null then
-- 			ref (self.model);
-- 			self.id_layout_changed := model.on_layout_changed
-- 			(on_layout_changed_for_view'access, self);
-- 			self.id_selection_changed := model.on_selection_changed
-- 			(on_selection_changed_for_view'access, self);
-- 			self.id_item_contents_changed := model.on_item_contents_changed
-- 			(on_item_contents_changed_for_view'access, self);
-- 			self.id_item_destroyed :=
-- 			model.on_item_destroyed (on_item_destroyed_for_view'access, self);
-- 		end if;
-- 
-- 		if self.model /= null and then self.model.layout = null then
-- 			self.model.layout := self.layout;  --  needed for layout
-- 			ref (self.model.layout);
-- 			self.model.refresh_layout;
-- 		else
-- 			set_adjustment_values (self);
-- 			self.queue_draw;
-- 		end if;
-- 
-- 		self.viewport_changed;
	end set_model;
	
	procedure initialize_view (
		self  : not null access type_view'class;
		model : access type_model'class := null) is
		use glib.object;
	begin
		g_new (self, view_get_type);

-- 		self.layout := self.create_pango_layout;
-- 		self.set_has_window (true);
-- 
-- 		self.add_events
-- 		(scroll_mask or smooth_scroll_mask or touch_mask
-- 			or button_press_mask or button_release_mask
-- 			or button1_motion_mask
-- 			or button2_motion_mask
-- 			or button3_motion_mask
-- 			--  or pointer_motion_mask or pointer_motion_hint_mask
-- 		);
-- 
-- 		self.on_destroy (on_view_destroy'access);
-- 		self.on_button_press_event (on_button_event'access);
-- 		self.on_button_release_event (on_button_event'access);
-- 		self.on_motion_notify_event (on_motion_notify_event'access);
-- 		self.on_key_press_event (on_key_event'access);
-- 		self.on_scroll_event (on_scroll_event'access);
-- 
-- 		self.set_can_focus (true);
-- 
		self.set_model (model);
-- 		set_model (self, model);
	end initialize_view;

	
	procedure new_view (
		self  : out type_view_pointer;
		model : access type_model := null) is
	begin
		self := new type_view;
		initialize_view (self, model);
	end;
	


-- 	procedure draw (
-- 		self	: not null access type_item;
-- 		context : draw_context) is
-- 	begin
-- 		null;
-- 	end;

begin
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

	-- canvas in scrolled box

	-- model
	model := new type_model;
	init_model (model);

	-- view
	new_view (view, model);
-- 	initialize (canvas);
	add (scrolled, view);

	-- context
-- 	context := build_context (canvas);

-- 	set_grid_size (canvas);
-- 	draw_internal (canvas, context, model_rec);

-- 	item_pointer := new type_item;
-- 	add (self => model,
-- 		item => item_pointer);

	--      Self : not null access List_Canvas_Model_Record;
--       Item : not null access Abstract_Item_Record'Class);
   --  Add a new item to the model.

	
-- 	draw (dummy, cr);
	
	window.on_destroy (callbacks_3.terminate_main'access);
	
	window.show_all;

	gtk.main.main;

end;
