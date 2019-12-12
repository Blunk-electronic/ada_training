with ada.text_io;			use ada.text_io;

with interfaces.c.strings;	use interfaces.c.strings;

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
with gtk.handlers;			use gtk.handlers;
with gtk.scrolled_window;	use gtk.scrolled_window;
with gtk.adjustment;		use gtk.adjustment;
with gtk.bin;				use gtk.bin;
with gtk.scrollable;		use gtk.scrollable;
with gtk.style_context;		use gtk.style_context;

with glib;					use glib;
with glib.object;			use glib.object;
with glib.values;			use glib.values;
with glib.properties.creation;	use glib.properties.creation;
with cairo;					use cairo;
with cairo.pattern;			use cairo.pattern;
with gtkada.style;     		use gtkada.style;
with gtkada.types;			use gtkada.types;
with gtkada.handlers;		use gtkada.handlers;
with gtkada.bindings;		use gtkada.bindings;
with gdk;					use gdk;
with gdk.window;			use gdk.window;
with gdk.window_attr;		use gdk.window_attr;
with gdk.event;				use gdk.event;

with gdk.rgba;
with pango.layout;			use pango.layout;
with system.storage_elements;            use system.storage_elements;

with ada.containers;		use ada.containers;
with ada.containers.doubly_linked_lists;

-- with gtkada.canvas_view.views;           use gtkada.canvas_view.views;

package body canvas_test is

	model_signals : constant gtkada.types.chars_ptr_array := (
-- 		1 => new_string (string (signal_item_contents_changed)),
		1 => new_string (string (signal_layout_changed))
-- 		3 => new_string (string (signal_selection_changed)),
		-- 		2 => new_string (string (signal_item_destroyed))
		);
	
	view_signals : constant gtkada.types.chars_ptr_array := (
		1 => new_string (string (signal_viewport_changed))
-- 		2 => new_string (string (signal_item_event)),
-- 		3 => new_string (string (signal_inline_editing_started)),
-- 		4 => new_string (string (signal_inline_editing_finished))
		);

	h_adj_property    : constant property_id := 1;
	v_adj_property    : constant property_id := 2;
	h_scroll_property : constant property_id := 3;
	v_scroll_property : constant property_id := 4;

	model_class_record : glib.object.ada_gobject_class := glib.object.uninitialized_class;
	view_class_record : aliased glib.object.ada_gobject_class := glib.object.uninitialized_class;
	
	function model_get_type return glib.gtype is begin
		glib.object.initialize_class_record (
			ancestor     => gtype_object,
			signals      => model_signals,
			class_record => model_class_record,
			type_name    => "gtkada_model",
			parameters   => (
-- 				1 => (1 => gtype_pointer), 	-- item_content_changed
				1 => (1 => gtype_none)  	-- layout_changed
-- 				3 => (1 => gtype_pointer),	-- selection_changed
-- 				4 => (1 => gtype_pointer)) 	-- item_destroyed
				)
			);  
		return model_class_record.the_type;
	end model_get_type;

	
	procedure init (self : not null access type_model'class) is begin
		if not self.is_created then
			g_new (self, model_get_type);
		end if;
	end;
	
	procedure gtk_new (self : out type_model_ptr) is begin
		self := new type_model;
		init (self);
	end;	

	canvas_class_record : aliased glib.object.ada_gobject_class := glib.object.uninitialized_class;

	function view_to_model (
		self   : not null access type_canvas;
		rect   : type_view_rectangle) 
		return type_model_rectangle is
	begin
		return (x      => rect.x / self.scale + self.topleft.x,
				y      => rect.y / self.scale + self.topleft.y,
				width  => rect.width / self.scale,
				height => rect.height / self.scale);
	end view_to_model;
	
	function get_visible_area (self : not null access type_canvas)
		return type_model_rectangle is
	begin
		return self.view_to_model
		((0.0,
			0.0,
			gdouble (self.get_allocated_width),
			gdouble (self.get_allocated_height)));
	end get_visible_area;

	function bounding_box (
		self   : not null access type_model;
		margin : type_model_coordinate := 0.0)
		return type_model_rectangle
	is
		result : type_model_rectangle;
		is_first : boolean := true;

-- 		procedure do_item (item : not null access abstract_item_record'class);
-- 		procedure do_item (item : not null access abstract_item_record'class) is
-- 			box : constant model_rectangle := item.model_bounding_box;
-- 		begin
-- 			if is_first then
-- 			is_first := false;
-- 			result := box;
-- 			else
-- 			union (result, box);
-- 			end if;
-- 		end do_item;
	begin
-- 		canvas_model_record'class (self.all).for_each_item
-- 		(do_item'access);
-- 
-- 		if is_first then
-- 			return no_rectangle;
-- 		else
-- 			result.x := result.x - margin;
-- 			result.y := result.y - margin;
-- 			result.width := result.width + 2.0 * margin;
-- 			result.height := result.height + 2.0 * margin;
			return result;
-- 		end if;
	end bounding_box;

	procedure viewport_changed (self : not null access type_canvas'class) is begin
		object_callback.emit_by_name (self, signal_viewport_changed);
	end viewport_changed;
	
	procedure set_adjustment_values (self : not null access type_canvas'class) is
		box   : type_model_rectangle;
		area  : constant type_model_rectangle := self.get_visible_area;
		min, max : gdouble;
	begin
		if self.model = null or else area.width <= 1.0 then
			--  not allocated yet
			return;
		end if;

		--  we want a small margin around the minimal box for the model, since it
		--  looks better.

		box := self.model.bounding_box (view_margin / self.scale);

		--  we set the adjustments to include the model area, but also at least
		--  the current visible area (if we don't, then part of the display will
		--  not be properly refreshed).

		if self.hadj /= null then
			min := gdouble'min (area.x, box.x);
			max := gdouble'max (area.x + area.width, box.x + box.width);
			self.hadj.configure
			(value          => area.x,
			lower          => min,
			upper          => max,
			step_increment => 5.0,
			page_increment => 100.0,
			page_size      => area.width);
		end if;

		if self.vadj /= null then
			min := gdouble'min (area.y, box.y);
			max := gdouble'max (area.y + area.height, box.y + box.height);
			self.vadj.configure
			(value          => area.y,
			lower          => min,
			upper          => max,
			step_increment => 5.0,
			page_increment => 100.0,
			page_size      => area.height);
		end if;

		self.viewport_changed;
	end set_adjustment_values;

	procedure on_adj_value_changed (view : access glib.object.gobject_record'class) is
	-- Called when one of the scrollbars has changed value.		
		self : constant type_canvas_ptr := type_canvas_ptr (view);
		pos  : constant type_model_point := (
							x => self.hadj.get_value,
							y => self.vadj.get_value);
	begin
		if pos /= self.topleft then
			self.topleft := pos;
			self.viewport_changed;
			queue_draw (self);
		end if;
	end on_adj_value_changed;

	procedure view_set_property (
		object        : access glib.object.gobject_record'class;
		prop_id       : property_id;
		value         : glib.values.gvalue;
		property_spec : param_spec)
	is
		pragma unreferenced (property_spec);
		self : constant type_canvas_ptr := type_canvas_ptr (object);
	begin
		case prop_id is
			when h_adj_property =>
				self.hadj := gtk_adjustment (get_object (value));
				if self.hadj /= null then
					set_adjustment_values (self);
					self.hadj.on_value_changed (on_adj_value_changed'access, self);
					self.queue_draw;
				end if;

			when v_adj_property => 

				self.vadj := gtk_adjustment (get_object (value));

				if self.vadj /= null then
					set_adjustment_values (self);
					self.vadj.on_value_changed (on_adj_value_changed'access, self);
					self.queue_draw;
				end if;

			when h_scroll_property => null;

			when v_scroll_property => null;

			when others => null;
		end case;
	end view_set_property;
	
	procedure view_get_property (
		object        : access glib.object.gobject_record'class;
		prop_id       : property_id;
		value         : out glib.values.gvalue;
		property_spec : param_spec)
	is
		pragma unreferenced (property_spec);
		self : constant type_canvas_ptr := type_canvas_ptr (object);
	begin
		case prop_id is
			when h_adj_property => set_object (value, self.hadj);

			when v_adj_property => set_object (value, self.vadj);

			when h_scroll_property => set_enum (value, gtk_policy_type'pos (policy_automatic));

			when v_scroll_property => set_enum (value, gtk_policy_type'pos (policy_automatic));

			when others => null;
		end case;
	end view_get_property;

	procedure refresh (
		self : not null access type_canvas'class;
		cr   : cairo.cairo_context;
		area : type_model_rectangle := no_rectangle)
	is
		a : type_model_rectangle;
		c : type_draw_context;
	begin
		if area = no_rectangle then
			a := self.get_visible_area;
		else
			a := area;
		end if;

		--  gdk already clears the exposed area to the background color, so
		--  we do not need to clear ourselves.

		c := (
			cr		=> cr,
			layout	=> self.layout,
			view	=> type_canvas_ptr (self));

		save (cr);
-- 		self.set_transform (cr);
-- 		self.draw_internal (c, a);
		restore (cr);
	end refresh;
	
	function on_view_draw (
		view	: system.address; 
		cr		: cairo_context) return gboolean;
	
	pragma convention (c, on_view_draw);
	--  default handler for "draw" on views.

	function on_view_draw (
		view	: system.address; 
		cr		: cairo_context) return gboolean is
		
		self : constant type_canvas_ptr := type_canvas_ptr (glib.object.convert (view));
		x1, y1, x2, y2 : gdouble;
	begin
		clip_extents (cr, x1, y1, x2, y2);

		if x2 < x1 or else y2 < y1 then
			refresh (self, cr);
		else
			refresh (self, cr, self.view_to_model ((x1, y1, x2 - x1, y2 - y1)));
		end if;

		--  we might have an inline widget, which we need to draw.
-- 		if self.inline_edit.item /= null then
-- 			if inherited_draw (view_class_record, widget => self, cr => cr) then
-- 				return 1;
-- 			else
-- 				return 0;
-- 			end if;
-- 		else
			return 1;
-- 		end if;

	exception
		when e : others =>
			process_exception (e);
			return 0;
	end on_view_draw;

	procedure on_view_realize (widget : system.address);
	pragma convention (c, on_view_realize);
	--  called when the view is realized
	
	procedure on_view_realize (widget : system.address) is
		w          : constant gtk_widget := gtk_widget (get_user_data_or_null (widget));
		allocation : gtk_allocation;
		window     : gdk_window;
		attr       : gdk.window_attr.gdk_window_attr;
		mask       : gdk_window_attributes_type;
	begin
		if not w.get_has_window then
			inherited_realize (view_class_record, w);
		else
			w.set_realized (true);
			w.get_allocation (allocation);

			gdk_new
			(attr,
			window_type => gdk.window.window_child,
			x           => allocation.x,
			y           => allocation.y,
			width       => allocation.width,
			height      => allocation.height,
			wclass      => gdk.window.input_output,
			visual      => w.get_visual,
			event_mask  => w.get_events or exposure_mask);
			mask := wa_x or wa_y or wa_visual;

			gdk_new (window, w.get_parent_window, attr, mask);
			register_window (w, window);
			w.set_window (window);
			get_style_context (w).set_background (window);

			--  see also handler for size_allocate, which moves the window to its
			--  proper location.
		end if;
	end on_view_realize;
	
	procedure canvas_class_init (self : gobject_class);
	pragma convention (c, canvas_class_init);
	
	procedure canvas_class_init (self : gobject_class) is begin
		set_properties_handlers (self, view_set_property'access, view_get_property'access);

		override_property (self, h_adj_property, "hadjustment");
		override_property (self, v_adj_property, "vadjustment");
		override_property (self, h_scroll_property, "hscroll-policy");
		override_property (self, v_scroll_property, "vscroll-policy");

		set_default_draw_handler (self, on_view_draw'access);
-- 		set_default_size_allocate_handler (self, on_size_allocate'access);
		set_default_realize_handler (self, on_view_realize'access);
	end;
	
	function canvas_get_type return glib.gtype is
		info : access ginterface_info;
	begin
		if glib.object.initialize_class_record (
			ancestor     => gtk.bin.get_type,
			signals      => view_signals,
			class_record => canvas_class_record'access,
			type_name    => "gtkada_canvas",
			parameters   => (
				1 => (1 => gtype_none)
-- 				2 => (1 => gtype_pointer),
-- 				3 => (1 => gtype_pointer),
-- 				4 => (1 => gtype_pointer)
				),
			returns      => (1 => gtype_none, 2 => gtype_boolean),
			class_init   => canvas_class_init'access
			)
		then
			info := new ginterface_info' (
				interface_init     => null,
				interface_finalize => null,
				interface_data     => system.null_address);
				glib.object.add_interface (
					canvas_class_record,
					iface => gtk.scrollable.get_type,
					info  => info
				);
		end if;

		return canvas_class_record.the_type;
	end canvas_get_type;

	procedure layout_changed (self : not null access type_model'class) is begin
		object_callback.emit_by_name (self, signal_layout_changed);
	end layout_changed;
	
	function on_layout_changed (
		self : not null access type_model'class;
		call : not null access procedure (self : not null access gobject_record'class);
		slot : access gobject_record'class := null)
		return gtk.handlers.handler_id is
	begin
		if slot = null then
			return object_callback.connect (
				self,
				signal_layout_changed,
				object_callback.to_marshaller (call));
		else
			return object_callback.object_connect (
				self,
				signal_layout_changed,
				object_callback.to_marshaller (call),
				slot);
		end if;
	end on_layout_changed;

	procedure on_layout_changed_for_view (view : not null access gobject_record'class) is
		self  : constant type_canvas_ptr := type_canvas_ptr (view);
		alloc : gtk_allocation;
	begin
		self.get_allocation (alloc);

		--  on_adjustments_set will be called anyway when size_allocate is called
		--  so no need to call it now if the size is unknown yet.

		if alloc.width > 1 then
			set_adjustment_values (self);
			self.queue_draw;
		end if;

-- 		move_inline_edit_widget (self);
	end on_layout_changed_for_view;

	procedure refresh_layout (
		self        : not null access type_model;
		send_signal : boolean := true)
	is
		context : constant type_draw_context := (
					cr		=> <>,
					layout 	=> self.layout,
					view	=> null);

-- 		procedure do_container_layout (item : not null access abstract_item_record'class);
-- 		procedure do_container_layout (item : not null access abstract_item_record'class) is
-- 		begin
-- 			item.refresh_layout (context);
-- 		end do_container_layout;

	begin
-- 		type_model'class (self.all).for_each_item (do_container_layout'access, filter => kind_item);
-- 		refresh_link_layout (self);

		if send_signal then
			type_model'class (self.all).layout_changed;
		end if;
	end refresh_layout;
   
	procedure set_model (
		self  : not null access type_canvas'class;
		model : access type_model'class) is
	begin
		--if self.model = canvas_model (model) then
		if self.model = type_model_ptr (model) then
			return;
		end if;

		if self.model /= null then
			disconnect (self.model, self.id_layout_changed);
-- 			disconnect (self.model, self.id_item_contents_changed);
-- 			disconnect (self.model, self.id_selection_changed);
-- 			disconnect (self.model, self.id_item_destroyed);
			unref (self.model);
		end if;

		self.model := type_model_ptr (model);

		if self.model /= null then
			ref (self.model);
			self.id_layout_changed := model.on_layout_changed (on_layout_changed_for_view'access, self);
-- 			self.id_selection_changed := model.on_selection_changed (on_selection_changed_for_view'access, self);
-- 			self.id_item_contents_changed := model.on_item_contents_changed (on_item_contents_changed_for_view'access, self);
-- 			self.id_item_destroyed := model.on_item_destroyed (on_item_destroyed_for_view'access, self);
		end if;

		if self.model /= null and then self.model.layout = null then
			self.model.layout := self.layout;  --  needed for layout
			ref (self.model.layout);
			self.model.refresh_layout;
		else
			set_adjustment_values (self);
			self.queue_draw;
		end if;

		self.viewport_changed;
	end set_model;

	procedure on_view_destroy (self : access gtk_widget_record'class) is
		s : constant type_canvas_ptr := type_canvas_ptr (self);
	begin
-- 		cancel_continuous_scrolling (s);
-- 		terminate_animation (s);

		if s.model /= null then
			unref (s.model);
			s.model := null;
		end if;

		if s.layout /= null then
			unref (s.layout);
			s.layout := null;
		end if;
	end on_view_destroy;
	
	procedure init (
		self  : not null access type_canvas'class;
		model : access type_model'class := null) is
	begin
		g_new (self, canvas_get_type);
		self.layout := self.create_pango_layout;
		self.set_has_window (true);

		self.add_events (
			scroll_mask or smooth_scroll_mask or touch_mask
				or button_press_mask or button_release_mask
				or button1_motion_mask
				or button2_motion_mask
				or button3_motion_mask
				--  or pointer_motion_mask or pointer_motion_hint_mask
			);

		self.on_destroy (on_view_destroy'access);
-- 		self.on_button_press_event (on_button_event'access);
-- 		self.on_button_release_event (on_button_event'access);
-- 		self.on_motion_notify_event (on_motion_notify_event'access);
-- 		self.on_key_press_event (on_key_event'access);
-- 		self.on_scroll_event (on_scroll_event'access);

		self.set_can_focus (true);

		self.set_model (model);
	end init;

	
	procedure gtk_new (
		self	: out type_canvas_ptr;
		model	: access type_model'class := null) is 
	begin
		self := new type_canvas;
		init (self, model);
	end;
	
end canvas_test;
