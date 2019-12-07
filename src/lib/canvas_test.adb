with ada.text_io;			use ada.text_io;

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
with gtk.adjustment;		use gtk.adjustment;
with gtk.bin;				use gtk.bin;
with gtk.scrollable;		use gtk.scrollable;

with glib;					use glib;
with glib.object;			use glib.object;
with glib.values;			use glib.values;
with glib.properties.creation;	use glib.properties.creation;
with cairo;					use cairo;
with cairo.pattern;			use cairo.pattern;
with gtkada.canvas_view;	use gtkada.canvas_view;
with gtkada.style;     		use gtkada.style;
with gdk.rgba;
with pango.layout;			use pango.layout;
with system.storage_elements;            use system.storage_elements;

with ada.containers;		use ada.containers;
with ada.containers.doubly_linked_lists;

-- with gtkada.canvas_view.views;           use gtkada.canvas_view.views;

package body canvas_test is

	procedure dummy is begin null; end;

	canvas_class_record : aliased glib.object.ada_gobject_class := glib.object.uninitialized_class;

-- 	view_signals : constant gtkada.types.chars_ptr_array :=
-- 		(1 => new_string (string (signal_viewport_changed)),
-- 		2 => new_string (string (signal_item_event)),
-- 		3 => new_string (string (signal_inline_editing_started)),
-- 		4 => new_string (string (signal_inline_editing_finished)));

	h_adj_property    : constant property_id := 1;
	v_adj_property    : constant property_id := 2;
	h_scroll_property : constant property_id := 3;
	v_scroll_property : constant property_id := 4;

-- 	procedure set_adjustment_values
-- 		(self : not null access type_view'class)
-- 	is
-- 		box   : model_rectangle;
-- 		area  : constant model_rectangle := self.get_visible_area;
-- 		min, max : gdouble;
-- 	begin
-- 		if self.model = null or else area.width <= 1.0 then
-- 			--  not allocated yet
-- 			return;
-- 		end if;
-- 
-- 		--  we want a small margin around the minimal box for the model, since it
-- 		--  looks better.
-- 
-- 		box := self.model.bounding_box (view_margin / self.scale);
-- 
-- 		--  we set the adjustments to include the model area, but also at least
-- 		--  the current visible area (if we don't, then part of the display will
-- 		--  not be properly refreshed).
-- 
-- 		if self.hadj /= null then
-- 			min := gdouble'min (area.x, box.x);
-- 			max := gdouble'max (area.x + area.width, box.x + box.width);
-- 			self.hadj.configure
-- 			(value          => area.x,
-- 			lower          => min,
-- 			upper          => max,
-- 			step_increment => 5.0,
-- 			page_increment => 100.0,
-- 			page_size      => area.width);
-- 		end if;
-- 
-- 		if self.vadj /= null then
-- 			min := gdouble'min (area.y, box.y);
-- 			max := gdouble'max (area.y + area.height, box.y + box.height);
-- 			self.vadj.configure
-- 			(value          => area.y,
-- 			lower          => min,
-- 			upper          => max,
-- 			step_increment => 5.0,
-- 			page_increment => 100.0,
-- 			page_size      => area.height);
-- 		end if;
-- 
-- 		self.viewport_changed;
-- 	end set_adjustment_values;

	
	
-- 	procedure canvas_set_property
-- 		(object        : access glib.object.gobject_record'class;
-- 		prop_id       : property_id;
-- 		value         : glib.values.gvalue;
-- 		property_spec : param_spec)
-- 	is
-- 		pragma unreferenced (property_spec);
-- 		self : constant type_canvas_ptr := type_canvas_ptr (object);
-- 	begin
-- 		case prop_id is
-- 			when h_adj_property =>
-- 			self.hadj := gtk_adjustment (get_object (value));
-- 			if self.hadj /= null then
-- 				set_adjustment_values (self);
-- 				self.hadj.on_value_changed (on_adj_value_changed'access, self);
-- 				self.queue_draw;
-- 			end if;
-- 
-- 			when v_adj_property =>
-- 			self.vadj := gtk_adjustment (get_object (value));
-- 			if self.vadj /= null then
-- 				set_adjustment_values (self);
-- 				self.vadj.on_value_changed (on_adj_value_changed'access, self);
-- 				self.queue_draw;
-- 			end if;
-- 
-- 			when h_scroll_property =>
-- 			null;
-- 
-- 			when v_scroll_property =>
-- 			null;
-- 
-- 			when others =>
-- 			null;
-- 		end case;
-- 	end canvas_set_property;


	
-- 	procedure canvas_class_init (self : gobject_class);
-- 	pragma convention (c, canvas_class_init);

-- 	procedure canvas_class_init (self : gobject_class) is
-- 	begin
-- 		set_properties_handlers (self, canvas_set_property'access, view_get_property'access);
-- 
-- 		override_property (self, h_adj_property, "hadjustment");
-- 		override_property (self, v_adj_property, "vadjustment");
-- 		override_property (self, h_scroll_property, "hscroll-policy");
-- 		override_property (self, v_scroll_property, "vscroll-policy");
-- 
-- 		set_default_draw_handler (self, on_view_draw'access);
-- 		set_default_size_allocate_handler (self, on_size_allocate'access);
-- 		set_default_realize_handler (self, on_view_realize'access);
-- 	end canvas_class_init;
	
	function canvas_get_type return glib.gtype is
		info : access ginterface_info;
	begin
		if glib.object.initialize_class_record
		(ancestor     => gtk.bin.get_type,
-- 			signals      => view_signals,
			class_record => canvas_class_record'access,
			type_name    => "gtkadacanvasview",
			parameters   => (1 => (1 => gtype_none),
							2 => (1 => gtype_pointer),
							3 => (1 => gtype_pointer),
							4 => (1 => gtype_pointer)),
			returns      => (1 => gtype_none,
							2 => gtype_boolean)
-- 			class_init   => canvas_class_init'access
		)
		then
			info := new ginterface_info'
			(interface_init     => null,
			interface_finalize => null,
			interface_data     => system.null_address);
			glib.object.add_interface
			(canvas_class_record,
			iface => gtk.scrollable.get_type,
			info  => info);
		end if;

		return canvas_class_record.the_type;
	end canvas_get_type;

	
end canvas_test;
