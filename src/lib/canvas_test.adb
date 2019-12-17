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
with gdk.cairo;				use gdk.cairo;
with gdk.window;			use gdk.window;
with gdk.window_attr;		use gdk.window_attr;
with gdk.event;				use gdk.event;

with gdk.rgba;
with pango.layout;			use pango.layout;
with system.storage_elements;            use system.storage_elements;

with ada.unchecked_deallocation;
with ada.unchecked_conversion;
with ada.containers;		use ada.containers;
with ada.containers.doubly_linked_lists;

-- with gtkada.canvas_view.views;           use gtkada.canvas_view.views;

package body canvas_test is

	function to_string (d : in gdouble) return string is begin
		return gdouble'image (d);
	end;

	
	model_signals : constant gtkada.types.chars_ptr_array := (
-- 		1 => new_string (string (signal_item_contents_changed)),
		1 => new_string (string (signal_layout_changed))
-- 		3 => new_string (string (signal_selection_changed)),
		-- 		2 => new_string (string (signal_item_destroyed))
		);
	
	view_signals : constant gtkada.types.chars_ptr_array := (
		1 => new_string (string (signal_viewport_changed)),
		2 => new_string (string (signal_item_event))
-- 		3 => new_string (string (signal_inline_editing_started)),
-- 		4 => new_string (string (signal_inline_editing_finished))
		);

	h_adj_property    : constant property_id := 1;
	v_adj_property    : constant property_id := 2;
	h_scroll_property : constant property_id := 3;
	v_scroll_property : constant property_id := 4;

	model_class_record : glib.object.ada_gobject_class := glib.object.uninitialized_class;
-- 	view_class_record : aliased glib.object.ada_gobject_class := glib.object.uninitialized_class;
	canvas_class_record : aliased glib.object.ada_gobject_class := glib.object.uninitialized_class;
	
	function model_get_type return glib.gtype is begin
		glib.object.initialize_class_record (
			ancestor     => gtype_object,
			signals      => model_signals,
			class_record => model_class_record,
			type_name    => "gtkada_model",
			parameters   => (
-- 				1 => (1 => gtype_pointer), 	-- item_contents_changed
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

	function model_to_view (
		self   : not null access type_canvas;
		p      : type_model_point) return type_view_point is
	begin
		return (x => (p.x - self.topleft.x) * self.scale,
				y => (p.y - self.topleft.y) * self.scale);
	end model_to_view;

	function model_to_view (
		self   : not null access type_canvas;
		rect   : type_model_rectangle) return type_view_rectangle is
		result : type_view_rectangle;
	begin
-- 		return (x      => (rect.x - self.topleft.x) * self.scale,
-- 				y      => (rect.y - self.topleft.y) * self.scale,
-- 				width  => rect.width * self.scale,
			-- 				height => rect.height * self.scale);

		result := (x      => (rect.x - self.topleft.x) * self.scale,
				y      => (rect.y - self.topleft.y) * self.scale,
				width  => rect.width * self.scale,
				height => rect.height * self.scale);

-- 		put_line ("view " & 
-- 					to_string (result.x) & " " &
-- 					to_string (result.y) & " " &
-- 					to_string (result.width) & " " &
-- 					to_string (result.height)
-- 					);
		
		return result;
	end model_to_view;

	function get_scale (self : not null access type_canvas) return gdouble is
	begin
		return self.scale;
	end get_scale;
	
	procedure set_scale (
		self     : not null access type_canvas;
		scale    : gdouble := 1.0;
		preserve : type_model_point := no_point)
	is
		box : type_model_rectangle;
		old_scale : constant gdouble := self.scale;
		p   : type_model_point;
	begin
		if preserve /= no_point then
			p := preserve;
		else
			box := self.get_visible_area;
			p := (box.x + box.width / 2.0, box.y + box.height / 2.0);
		end if;

		self.scale := scale;
		self.topleft := (
			p.x - (p.x - self.topleft.x) * old_scale / scale,
			p.y - (p.y - self.topleft.y) * old_scale / scale);

		self.scale_to_fit_requested := 0.0;
		self.set_adjustment_values;
		self.queue_draw;
	end set_scale;
	
	function get_visible_area (self : not null access type_canvas)
		return type_model_rectangle is
	begin
		return self.view_to_model
		((0.0,
			0.0,
			gdouble (self.get_allocated_width),
			gdouble (self.get_allocated_height)));
	end get_visible_area;

	procedure union (
		rect1 : in out type_model_rectangle;
		rect2 : type_model_rectangle) is
		right : constant type_model_coordinate := 
			type_model_coordinate'max (rect1.x + rect1.width, rect2.x + rect2.width);
		bottom : constant type_model_coordinate :=
			type_model_coordinate'max (rect1.y + rect1.height, rect2.y + rect2.height);
	begin
		rect1.x := type_model_coordinate'min (rect1.x, rect2.x);
		rect1.width := right - rect1.x;

		rect1.y := type_model_coordinate'min (rect1.y, rect2.y);
		rect1.height := bottom - rect1.y;
	end union;

	function item_to_model (
		item   : not null access type_item'class;
		rect   : type_item_rectangle) return type_model_rectangle
	is
-- 		parent : type_item_ptr := type_item_ptr (item);
		pos    : type_item_point;
		result : type_model_rectangle := (rect.x, rect.y, rect.width, rect.height);
	begin
-- 		while parent /= null loop
			--  ??? should take item rotation into account when we implement it.

-- 			pos := position (parent);
			pos := position (item);
			result.x := result.x + pos.x;
			result.y := result.y + pos.y;

-- 			parent := parent.parent;
-- 		end loop;

-- 			put_line ("bounding box model " & 
-- 					  to_string (result.x) & " " &
-- 					  to_string (result.y) & " " &
-- 					  to_string (result.width) & " " &
-- 					  to_string (result.height)
-- 					 );
			
		return result;
	end item_to_model;

	function item_to_model (
		item   : not null access type_item'class;
		p      : type_item_point) return type_model_point
	is
		r : constant type_model_rectangle := item.item_to_model ((p.x, p.y, 0.0, 0.0));
	begin
		return (r.x, r.y);
	end item_to_model;

	function bounding_box (self : not null access type_item) return type_item_rectangle is
	begin
		--  assumes size_request has been called already
-- 		return (0.0, 0.0, self.width, self.height);

		return (0.0, 0.0, 1000.0, 1000.0);
	end bounding_box;
	
	function model_bounding_box (self : not null access type_item'class) 
		return type_model_rectangle is
	begin
		return self.item_to_model (self.bounding_box);
	end model_bounding_box;
	
	function bounding_box (
		self   : not null access type_model;
		margin : type_model_coordinate := 0.0)
		return type_model_rectangle
	is
		result : type_model_rectangle;
		is_first : boolean := true;

		procedure do_item (item : not null access type_item'class) is
			box : constant type_model_rectangle := item.model_bounding_box;
		begin
			if is_first then
				is_first := false;
				result := box;
			else
				union (result, box);
			end if;
		end do_item;
	begin
		type_model'class (self.all).for_each_item (do_item'access);

-- 			put_line ("bounding box model total " & 
-- 					  to_string (result.x) & " " &
-- 					  to_string (result.y) & " " &
-- 					  to_string (result.width) & " " &
-- 					  to_string (result.height)
-- 					 );

		
		if is_first then
			return no_rectangle;
		else
			result.x := result.x - margin;
			result.y := result.y - margin;
			result.width := result.width + 2.0 * margin;
			result.height := result.height + 2.0 * margin;
			return result;
		end if;
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

	procedure set_transform (
		self	: not null access type_canvas;
		cr		: cairo.cairo_context;
		item	: access type_item'class := null)
	is
		model_p : type_model_point;
		p       : type_view_point;
	begin
		if item /= null then
			model_p := item.item_to_model ((0.0, 0.0));
		else
			model_p := (0.0, 0.0);
		end if;

		p := self.model_to_view (model_p);
		translate (cr, p.x, p.y);
		scale (cr, self.scale, self.scale);
	end set_transform;

	function get_visibility_threshold (self : not null access type_item) return gdouble is
	begin
		return self.visibility_threshold;
	end get_visibility_threshold;
	
	function size_above_threshold (
		self : not null access type_item'class;
		view : access type_canvas'class) return boolean
	is
		r   : type_view_rectangle;
		threshold : constant gdouble := self.get_visibility_threshold;
	begin
		if threshold = gdouble'last then
			--  always hidden
			return false;
		elsif threshold > 0.0 and then view /= null then
			r := view.model_to_view (self.model_bounding_box);
			if r.width < threshold or else r.height < threshold then
				return false;
			end if;
		end if;
		return true;
	end size_above_threshold;

	procedure draw (
		self 	: not null access type_item;
		context	: type_draw_context) is 
	begin
-- 		put_line ("drawing ...");

		cairo.set_line_width (context.cr, 1.1);
		cairo.set_source_rgb (context.cr, gdouble (1), gdouble (0), gdouble (0));

		cairo.move_to (context.cr, 0.0, 0.0);
		cairo.line_to (context.cr, 1000.0, 1000.0);

		cairo.move_to (context.cr, 1000.0, 0.0);
		cairo.line_to (context.cr, 0.0, 1000.0);

		cairo.rectangle (context.cr, 0.0, 0.0, 1000.0, 1000.0);
		
		cairo.stroke (context.cr);
	end;
	
	procedure translate_and_draw_item (
		self          : not null access type_item'class;
		context       : type_draw_context;
		as_outline    : boolean := false;
		outline_style : drawing_style := no_drawing_style)
	is
		pos : gtkada.style.point;
	begin
		if not size_above_threshold (self, context.view) then
			return;
		end if;

		save (context.cr);
		pos := self.position;
		translate (context.cr, pos.x, pos.y);

-- 		if as_outline then
-- 			self.draw_outline (outline_style, context);
-- 		elsif context.view /= null
-- 		and then context.view.model /= null
-- 		and then context.view.model.is_selected (self)
-- 		then
-- 			self.draw_as_selected (context);
-- 		else
			self.draw (context);
-- 		end if;
-- 
-- 		if debug_show_bounding_boxes then
-- 			declare
-- 			box : constant item_rectangle := self.bounding_box;
-- 			begin
-- 			gtk_new (stroke => (1.0, 0.0, 0.0, 0.8),
-- 						dashes => (2.0, 2.0))
-- 				.draw_rect (context.cr, (box.x, box.y), box.width, box.height);
-- 			end;
-- 		end if;

		restore (context.cr);

	exception
		when e : others =>
			restore (context.cr);
			process_exception (e);
	end translate_and_draw_item;

	procedure set_grid_size (
		self : not null access type_canvas'class;
		size : type_model_coordinate := 30.0) is
	begin
		self.grid_size := size;
	end set_grid_size;

	procedure draw_grid_dots (
		self    : not null access type_canvas'class;
		style   : gtkada.style.drawing_style;
		context : type_draw_context;
		area    : type_model_rectangle)
	is
		tmpx, tmpy  : gdouble;
	begin
		if style.get_fill /= null_pattern then
			set_source (context.cr, style.get_fill);
			paint (context.cr);
		end if;

		if self.grid_size /= 0.0 then
			new_path (context.cr);

			tmpx := gdouble (gint (area.x / self.grid_size)) * self.grid_size;
			
			while tmpx < area.x + area.width loop
				tmpy := gdouble (gint (area.y / self.grid_size)) * self.grid_size;
				
				while tmpy < area.y + area.height loop
					rectangle (context.cr, tmpx - 0.5, tmpy - 0.5, 1.0, 1.0);
					tmpy := tmpy + self.grid_size;
				end loop;

				tmpx := tmpx + self.grid_size;
			end loop;

			style.finish_path (context.cr);
		end if;
	end draw_grid_dots;
	
	procedure draw_internal (
		self    : not null access type_canvas;
		context : type_draw_context;
		area    : type_model_rectangle)
	is
-- 		s  : item_sets.set;

-- 		procedure draw_item
-- 		(item : not null access abstract_item_record'class);
		procedure draw_item (
			item : not null access type_item'class) is
		begin
			--  if the item is not displayed explicitly afterwards.
-- 			if not self.in_drag
-- 			or else not s.contains (abstract_item (item))
-- 			then
			translate_and_draw_item (item, context);
-- 			end if;
		end draw_item;

-- 		procedure add_to_set (item : not null access abstract_item_record'class);
-- 		procedure add_to_set (
-- 			item : not null access abstract_item_record'class) is
-- 		begin
-- 			s.include (abstract_item (item));
-- 		end add_to_set;

-- 		use item_drag_infos, item_sets;
-- 		c  : item_drag_infos.cursor;
		-- 		c2 : item_sets.cursor;

		-- prepare draing style so that white grid dots will be drawn.
		style : drawing_style := gtk_new (stroke => gdk.rgba.white_rgba);
		
	begin
-- 		put_line ("draw internal ...");
		
		if self.model /= null then

			-- Additional statements inserted according to advise in
			-- child package gtkada.canvas_view.views:

			-- draw a black background:
			set_source_rgb (context.cr, 0.0, 0.0, 0.0);
			paint (context.cr);

			-- draw white grid dots:
			set_grid_size (self, 100.0);
			draw_grid_dots (self, style, context, area);
			
			--  we must always draw the selected items and their links explicitly
			--  (since the model might not have been updated yet if we are during
			--  an automatic scrolling for instance, using a rtree).

-- 			if self.in_drag then
-- 			c := self.dragged_items.first;
-- 			while has_element (c) loop
-- 				s.include (element (c).item);  --  toplevel items
-- 				next (c);
-- 			end loop;
-- 			self.model.for_each_link (add_to_set'access, from_or_to => s);
-- 			end if;

			--  draw the active smart guides if needed
-- 			if self.in_drag
-- 			and then self.last_button_press.allow_snapping
-- 			and then self.snap.smart_guides
-- 			and then not self.dragged_items.is_empty
-- 			then
-- 			draw_visible_smart_guides
-- 				(self, context, element (self.dragged_items.first).item);
-- 			end if;

-- 			self.model.for_each_item (draw_item'access, in_area => area, filter => kind_link);
-- 			self.model.for_each_item (draw_item'access, in_area => area, filter => kind_item);

			self.model.for_each_item (draw_item'access, in_area => area);
-- 			self.model.for_each_item (draw_item'access); -- CS
			
-- 			if self.in_drag then
-- 			c2 := s.first;
-- 			while has_element (c2) loop
-- 				translate_and_draw_item (element (c2), context);
-- 				next (c2);
-- 			end loop;
-- 			end if;
		end if;
	end draw_internal;
	
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
		self.set_transform (cr);
		self.draw_internal (c, a);
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
			inherited_realize (canvas_class_record, w);
		else
			w.set_realized (true);
			w.get_allocation (allocation);

			gdk_new (
				attr,
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

	procedure on_size_allocate (view : system.address; alloc : gtk_allocation);
	pragma convention (c, on_size_allocate);
	--  default handler for "size_allocate" on views.
	
	procedure on_size_allocate (view : system.address; alloc : gtk_allocation) is
		self : constant type_canvas_ptr := type_canvas_ptr (glib.object.convert (view));
		salloc : gtk_allocation := alloc;
	begin
		--  for some reason, when we maximize the toplevel window in testgtk, or
		--  at least enlarge it horizontally, we are starting to see an alloc
		--  with x < 0 (likely related to the gtkpaned). the drawing area then
		--  moves the gdkwindow, which would introduce an extra ofset in the
		--  display (and influence the clipping done automatically by gtk+
		--  before it emits "draw"). so we prevent the automatic offseting done
		--  by gtkdrawingarea.

		salloc.x := 0;
		salloc.y := 0;
		self.set_allocation (salloc);
		set_adjustment_values (self);

		if self.get_realized then
			if self.get_has_window then
			move_resize
				(self.get_window, alloc.x, alloc.y, alloc.width, alloc.height);
			end if;

			--  send_configure event ?
		end if;

		--  are we in the middle of inline-editing ?
		--move_inline_edit_widget (self);

		if self.scale_to_fit_requested /= 0.0 then
			self.scale_to_fit
			(rect      => self.scale_to_fit_area,
			max_scale => self.scale_to_fit_requested);
		end if;
	end on_size_allocate;
	
	procedure view_class_init (self : gobject_class);
	pragma convention (c, view_class_init);
	
	procedure view_class_init (self : gobject_class) is begin
		set_properties_handlers (self, view_set_property'access, view_get_property'access);

		override_property (self, h_adj_property, "hadjustment");
		override_property (self, v_adj_property, "vadjustment");
		override_property (self, h_scroll_property, "hscroll-policy");
		override_property (self, v_scroll_property, "vscroll-policy");

		set_default_draw_handler (self, on_view_draw'access);
		set_default_size_allocate_handler (self, on_size_allocate'access);
		set_default_realize_handler (self, on_view_realize'access);
	end;
	
	function view_get_type return glib.gtype is
		info : access ginterface_info;
	begin
		if glib.object.initialize_class_record (
			ancestor     => gtk.bin.get_type,
			signals      => view_signals,
			class_record => canvas_class_record'access,
			type_name    => "GtkadaCanvasView",
			parameters   => (
				1 => (1 => gtype_none),
				2 => (1 => gtype_pointer)
-- 				3 => (1 => gtype_pointer),
-- 				4 => (1 => gtype_pointer)
				),
			returns      => (1 => gtype_none, 2 => gtype_boolean),
			class_init   => view_class_init'access
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
	end view_get_type;

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

	function intersects (rect1, rect2 : type_model_rectangle) return boolean is begin
		return not (
			rect1.x > rect2.x + rect2.width            --  r1 on the right of r2
			or else rect2.x > rect1.x + rect1.width    --  r2 on the right of r1
			or else rect1.y > rect2.y + rect2.height   --  r1 below r2
			or else rect2.y > rect1.y + rect1.height); --  r1 above r2
	end intersects;
	
	procedure for_each_item (
		self		: not null access type_model;
		callback	: not null access procedure (item : not null access type_item'class);
-- 		selected_only : boolean := false;
-- 		filter        : item_kind_filter := kind_any;
		in_area		: type_model_rectangle := no_rectangle)
	is
		use pac_items;
		c    : pac_items.cursor := self.items.first;
		item : type_item_ptr;
	begin
		while has_element (c) loop
			item := element (c);

			--  ??? might not work when the callback removes the item, which in
			--  turn removes a link which might happen to be the next element
			--  we were pointing to.
			next (c);

-- 			if (filter = kind_any
-- 				or else (filter = kind_item and then not item.is_link)
-- 				or else (filter = kind_link and then item.is_link))
-- 			and then
-- 				(not selected_only
-- 				or else list_canvas_model (self).is_selected (item))
-- 			and then
-- 				(in_area = no_rectangle
-- 				or else intersects (in_area, item.model_bounding_box))
-- 			then
-- 			callback (item);
-- 			end if;

			if (in_area = no_rectangle
				or else intersects (in_area, item.model_bounding_box))
			then
				callback (item);
			end if;
			
		end loop;
	end for_each_item;

	procedure size_request (
		self    : not null access type_item;
		context : type_draw_context) -- CS no need
	is
		use pac_items;
-- 		c     : pac_items.cursor := self.children.first;
-- 		child : container_item;
-- 		tmp, tmp2 : type_model_coordinate;
	begin
		-- CS
		self.width  := 1000.0;
		self.height := 1000.0;
	end size_request;

	procedure refresh_layout (
		self    : not null access type_item;
		context : type_draw_context) is
	begin
-- 		self.computed_position := self.position;
		type_item'class (self.all).size_request (context);
-- 		container_item_record'class (self.all).size_allocate; -- for children only. no need
-- 
-- 		self.computed_position.x :=
-- 		self.computed_position.x - (self.width * self.anchor_x);
-- 		self.computed_position.y :=
-- 		self.computed_position.y - (self.height * self.anchor_y);
	end refresh_layout;
	
	procedure refresh_layout (
		self        : not null access type_model;
		send_signal : boolean := true) 
	is
		context : constant type_draw_context := (
					cr		=> <>,
					layout 	=> self.layout,
					view	=> null);

		procedure do_container_layout (item : not null access type_item'class) is begin
			item.refresh_layout (context);
		end;

	begin
-- 		type_model'class (self.all).for_each_item (do_container_layout'access, filter => kind_item);
		type_model'class (self.all).for_each_item (do_container_layout'access);

		if send_signal then
			type_model'class (self.all).layout_changed;
		end if;
	end refresh_layout;
   
	procedure set_model (
		self  : not null access type_canvas'class;
		model : access type_model'class) is
	begin
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

	function view_to_model (
		self   : not null access type_canvas;
		p      : type_view_point) return type_model_point
	is
	begin
		return (x      => p.x / self.scale + self.topleft.x,
				y      => p.y / self.scale + self.topleft.y);
	end view_to_model;
	
	function window_to_model (
		self   : not null access type_canvas;
		p      : type_window_point) return type_model_point
	is
		alloc : gtk_allocation;
	begin
		self.get_allocation (alloc);
		return self.view_to_model (
			(
			x      => type_view_coordinate (p.x) - type_view_coordinate (alloc.x),
			y      => type_view_coordinate (p.y) - type_view_coordinate (alloc.y))
			);
	end window_to_model;

	function model_to_item (
		item   : not null access type_item'class;
		p      : type_model_rectangle) return type_item_rectangle
	is
		parent : type_item_ptr := type_item_ptr (item);
		result : type_item_rectangle := (p.x, p.y, p.width, p.height);
		pos    : type_item_point;
	begin
-- 		while parent /= null loop
			pos := parent.position;
			result.x := result.x - pos.x;
			result.y := result.y - pos.y;
-- 			parent := parent.parent;
-- 		end loop;
		return result;
	end model_to_item;

	function model_to_item (
		item   : not null access type_item'class;
		p      : type_model_point) return type_item_point
	is
		rect   : constant type_item_rectangle := model_to_item (item, (p.x, p.y, 1.0, 1.0));
	begin
		return (rect.x, rect.y);
	end model_to_item;
	

	function gvalue_to_eda (value : gvalue) return event_details_access is
		s : constant system.address := get_address (value);
		pragma warnings (off, "possible aliasing problem*");
		function unchecked_convert is new ada.unchecked_conversion (system.address, event_details_access);
		pragma warnings (on, "possible aliasing problem*");
	begin
		return unchecked_convert (s);
	end gvalue_to_eda;
	
	package eda_marshallers is new object_return_callback.marshallers.generic_marshaller (event_details_access, gvalue_to_eda);
	function eda_to_address is new ada.unchecked_conversion (event_details_access, system.address);
	
	function eda_emit is new eda_marshallers.emit_by_name_generic (eda_to_address);
	--  support for the "item_contents_changed" signal
	
	function item_event (
		self    : not null access type_canvas'class;
		details : event_details_access)
		return boolean is
	begin
		return eda_emit (self, signal_item_event & ascii.nul, details);
	end item_event;
	
	procedure compute_item (
		self    : not null access type_canvas'class;
		details : in out canvas_event_details)
	is
		context : type_draw_context;
	begin
		context := (
			cr     => gdk.cairo.create (self.get_window),
			view   => type_canvas_ptr (self),
			layout => null);

-- 		details.toplevel_item := self.model.toplevel_item_at (details.m_point, context => context);

-- 		if details.toplevel_item = null then
-- 			details.item := null;
-- 		else
-- 			details.t_point := details.toplevel_item.model_to_item (details.m_point);
-- 			details.item := details.toplevel_item.inner_most_item (details.m_point, context);

			if details.item /= null then
				details.i_point := details.item.model_to_item (details.m_point);
			end if;
-- 		end if;

		cairo.destroy (context.cr);
	end compute_item;
	
	function on_scroll_event (
		view  : access gtk_widget_record'class;
		event : gdk_event_scroll) return boolean
	is
		self    : constant type_canvas_ptr := type_canvas_ptr (view);
		details : aliased canvas_event_details;
		button  : guint;
	begin
		put_line ("scrolling ...");
		
		if self.model /= null then
			case event.direction is
				when scroll_up | scroll_left => button := 5;
				when scroll_down | scroll_right => button := 6;
				when scroll_smooth => 
					if event.delta_y > 0.0 then
						button := 6;
					else
						button := 5;
					end if;
			end case;

			details := (
				event_type => scroll,
				button     => button,
				key        => 0,
				state      => event.state,
				root_point => (event.x_root, event.y_root),
				m_point    => self.window_to_model ((x => event.x, y => event.y)),
-- 				t_point    => no_item_point,
				i_point    => no_item_point,
				item       => null
-- 				toplevel_item => null,
-- 				allow_snapping    => true,
-- 				allowed_drag_area => no_drag_allowed
				);
			
			compute_item (self, details);
-- 			
			return self.item_event (details'unchecked_access);
		end if;
		return false;
	end on_scroll_event;

	
	procedure init (
		self  : not null access type_canvas'class;
		model : access type_model'class := null) is
	begin
		g_new (self, view_get_type);
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

-- 		self.on_destroy (on_view_destroy'access);
-- 		self.on_button_press_event (on_button_event'access);
-- 		self.on_button_release_event (on_button_event'access);
-- 		self.on_motion_notify_event (on_motion_notify_event'access);
-- 		self.on_key_press_event (on_key_event'access);
-- 		self.on_scroll_event (on_scroll_event'access); -- CS

		self.set_can_focus (true);

		self.set_model (model);
	end init;

	function position (self : not null access type_item) return gtkada.style.point is
	begin
		return self.position;
	end position;
	
	procedure set_position (
		self  : not null access type_item;
		pos   : gtkada.style.point) is
	begin
		self.position := pos;
	end set_position;
	
	procedure gtk_new (
		self	: out type_canvas_ptr;
		model	: access type_model'class := null) is 
	begin
		self := new type_canvas;
		init (self, model);
	end;

	procedure add (
		self : not null access type_model;
		item : not null access type_item'class) is
	begin
		self.items.append (type_item_ptr (item));
	end add;

	procedure destroy_and_free (
		self     : in out type_item_ptr;
		in_model : not null access type_model'class) is
		
		procedure unchecked_free is new ada.unchecked_deallocation (type_item'class, type_item_ptr);
	begin
		if self /= null then
			unchecked_free (self);
		end if;
	end destroy_and_free;
	
	procedure remove (
		self : not null access type_model;
		item : not null access type_item'class) is
		i : type_item_ptr;
		use pac_items;
		c : pac_items.cursor;
	begin
		c := self.items.find (item);
		
		i := element (c);

		-- remove in items list
		self.items.delete (c);

		-- destroy in model
		destroy_and_free (i, self);
	end;

	procedure scale_to_fit (
		self      : not null access type_canvas;
		rect      : type_model_rectangle := no_rectangle;
		min_scale : gdouble := 1.0 / 4.0;
		max_scale : gdouble := 4.0;
		duration  : standard.duration := 0.0)
	is
		box     : type_model_rectangle;
		w, h, s : gdouble;
		alloc   : gtk_allocation;
		tl      : type_model_point;
		wmin, hmin : gdouble;
	begin
		put_line ("scale to fit ...");
		self.get_allocation (alloc);
		if alloc.width <= 1 then
			self.scale_to_fit_requested := max_scale;
			self.scale_to_fit_area := rect;

		elsif self.model /= null then
			self.scale_to_fit_requested := 0.0;
			
			if rect = no_rectangle then
				box := self.model.bounding_box;
			else
				box := rect;
			end if;

			if box.width /= 0.0 and then box.height /= 0.0 then
						  
				w := gdouble (alloc.width);
				h := gdouble (alloc.height);

				--  the "-1.0" below compensates for rounding errors, since
				--  otherwise we are still seeing the scrollbar along the axis
				--  used to compute the scale.
				wmin := (w - 2.0 * view_margin - 1.0) / box.width;
				hmin := (h - 2.0 * view_margin - 1.0) / box.height;
				wmin := gdouble'min (wmin, hmin);
				s := gdouble'min (max_scale, wmin);
				s := gdouble'max (min_scale, s);
				tl :=
					(x => box.x - (w / s - box.width) / 2.0,
					y => box.y - (h / s - box.height) / 2.0);

				if duration = 0.0 then
					self.scale := s;
					self.topleft := tl;
					self.set_adjustment_values;
					self.queue_draw;

-- 				else
-- 					animate_scale (self, s, duration => duration).start (self);
-- 					animate_scroll (self, tl, duration).start (self);
				end if;
			end if;
		end if;
	end scale_to_fit;
	
end canvas_test;
