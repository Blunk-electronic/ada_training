-- pragma ada_2012;

with gtk.main;
with gtk.window; 			use gtk.window;
with gtk.widget;  			use gtk.widget;
with gtk.box;				use gtk.box;
with gtk.button;     		use gtk.button;
with gtk.handlers;			use gtk.handlers;
with gtk.toolbar; 			use gtk.toolbar;
with gtk.tool_button;		use gtk.tool_button;
with gtk.enums;				use gtk.enums;
with gtk.gentry;			use gtk.gentry;
with gtk.combo_box_text;	use gtk.combo_box_text;
with gtk.frame;				use gtk.frame;
with gtk.scrolled_window;	use gtk.scrolled_window;
with gtk.adjustment;		use gtk.adjustment;
-- with gtk.bin;				use gtk.bin;

with gdk;
with gdk.types;

with glib;					use glib;
with glib.object;			use glib.object;
with glib.values;			use glib.values;
with cairo;					use cairo;
with cairo.pattern;			use cairo.pattern;
-- with gtkada.canvas_view;	use gtkada.canvas_view;
with gtkada.style;     		use gtkada.style;

with pango.layout;			use pango.layout;

with ada.containers;		use ada.containers;
with ada.containers.doubly_linked_lists;


package canvas_test is

	subtype type_model_coordinate is gdouble;

	no_position : constant gtkada.style.point := (gdouble'first, gdouble'first);
	
	type type_item is tagged record
		position : gtkada.style.point := no_position;
		
		visibility_threshold : gdouble := 0.0;
		
		width, height : type_model_coordinate;
		--  Computed by Size_Request. Always expressed in pixels.
	end record;
	
	type type_item_ptr is access all type_item'class;

	function get_visibility_threshold (self : not null access type_item) return gdouble;
	
	subtype type_item_coordinate is gdouble;
	
	type type_item_rectangle is record
		x, y, width, height : type_item_coordinate;
	end record;

	function bounding_box (self : not null access type_item) return type_item_rectangle;
	
	subtype type_item_point is gtkada.style.point;

	
	package pac_items is new doubly_linked_lists (type_item_ptr);
	
	type type_model is new glib.object.gobject_record with record
		layout	: pango.layout.pango_layout;
		items	: pac_items.list;
	end record;
	
	type type_model_ptr is access all type_model;
	
	procedure for_each_item (
		self     : not null access type_model;
		callback : not null access procedure (item : not null access type_item'class));

	


	type type_model_point is record
		x, y : type_model_coordinate;
	end record;
	
	type type_model_rectangle is record
		x, y, width, height : type_model_coordinate;
	end record;

	no_rectangle : constant type_model_rectangle := (0.0, 0.0, 0.0, 0.0);
	
	procedure init (self : not null access type_model'class);
   --  initialize the internal data so that signals can be sent.

	
	procedure gtk_new (self : out type_model_ptr);

	signal_layout_changed : constant glib.signal_name := "layout_changed";
	
	type type_canvas is new gtk.widget.gtk_widget_record with record
		model 		: type_model_ptr;
		topleft   	: type_model_point := (0.0, 0.0);
		scale     	: gdouble := 1.0;
		layout		: pango.layout.pango_layout;
		hadj, vadj	: gtk.adjustment.gtk_adjustment;

		--  connections to model signals
		id_layout_changed : gtk.handlers.handler_id := (gtk.handlers.null_handler_id, null);
		--id_item_contents_changed,
		--id_selection_changed
-- 		id_item_destroyed : gtk.handlers.handler_id := (gtk.handlers.null_handler_id, null);

		scale_to_fit_requested : gdouble := 0.0;
		scale_to_fit_area : type_model_rectangle;
	end record;
	
	type type_canvas_ptr is access all type_canvas'class;

	function get_visible_area (self : not null access type_canvas) return type_model_rectangle;
	--  return the area of the model that is currently displayed in the view.
	--  this is in model coordinates (since the canvas coordinates are always
	--  from (0,0) to (self.get_allocation_width, self.get_allocation_height).

	signal_viewport_changed : constant glib.signal_name := "viewport_changed";
	-- This signal is emitted whenever the view is zoomed or scrolled.


	
	subtype type_view_coordinate is gdouble;

	type type_view_point is record
		x, y : type_view_coordinate;
	end record;
	
	type type_view_rectangle is record
		x, y, width, height : type_view_coordinate;
	end record;

	function view_to_model (
		self   : not null access type_canvas;
		rect   : type_view_rectangle) 
		return type_model_rectangle;

	function model_to_view (
		self   : not null access type_canvas;
		rect   : type_model_rectangle) return type_view_rectangle;

	
	view_margin : constant type_view_coordinate := 20.0;
	--  The number of blank pixels on each sides of the view. This avoids having
	--  items displays exactly next to the border of the view.


	type type_draw_context is record
		cr     : cairo.cairo_context := cairo.null_context;
		layout : pango.layout.pango_layout := null;
		view   : type_canvas_ptr := null;
	end record;
	--  context to perform the actual drawing


	procedure refresh_layout (
		self    : not null access type_item;
		context : type_draw_context);
	
	procedure size_request (
		self    : not null access type_item;
		context : type_draw_context); -- CS no need

	procedure draw (
		self 	: not null access type_item;
		context	: type_draw_context);
	
	procedure set_transform (
		self   : not null access type_canvas;
		cr     : cairo.cairo_context;
		item	: access type_item'class := null);
	
	procedure draw_internal (
		self    : not null access type_canvas;
		context : type_draw_context;
		area    : type_model_rectangle);

	procedure set_position (
		self  : not null access type_item;
		pos   : gtkada.style.point);
	
	procedure gtk_new (
		self	: out type_canvas_ptr;
		model	: access type_model'class := null);

	procedure add (
		self : not null access type_model;
		item : not null access type_item'class);

	procedure scale_to_fit (
		self      : not null access type_canvas;
		rect      : type_model_rectangle := no_rectangle;
		min_scale : gdouble := 1.0 / 4.0;
		max_scale : gdouble := 4.0;
		duration  : standard.duration := 0.0);

	
	function canvas_get_type return glib.gtype;
	pragma convention (c, canvas_get_type);
	--  return the internal type

	
	subtype type_window_coordinate is gdouble;
	
	type type_window_point is record
		x, y : type_window_coordinate;
	end record;

	function view_to_model (
		self   : not null access type_canvas;
		p      : type_view_point) return type_model_point;
	
	function window_to_model (
		self   : not null access type_canvas;
		p      : type_window_point) return type_model_point;

	no_item_point : constant type_item_point := (gdouble'first, gdouble'first);

	function model_to_item (
		item   : not null access type_item'class;
		p      : type_model_rectangle) return type_item_rectangle;
	
	type canvas_event_type is (
		button_press, button_release, double_click,
		start_drag, in_drag, end_drag, key_press, scroll, custom);
	
	type canvas_event_details is record
		event_type     : canvas_event_type;
		button         : guint;

		state          : gdk.types.gdk_modifier_type;
		--  the modifier keys (shift, alt, control). it can be used to activate
		--  different behavior in such cases.

		key            : gdk.types.gdk_key_type;
		--  the key that was pressed (for key events)

		root_point     : gtkada.style.point;
		--  coordinates in root window.
		--  attributes of the low-level event.
		--   this is an implementation detail for proper handling of dragging.

		m_point        : type_model_point;
		--  where in the model the user clicked. this is independent of the zoom
		--  level or current scrolling.

		item           : type_item_ptr;
		--  the actual item that was clicked.
		--  set to null when the user clicked in the background.

-- 		toplevel_item  : abstract_item;
		--  the toplevel item that contains item (might be item itself).
		--  set to null when the user clicked in the background.

-- 		t_point        : item_point;
		--  the corodinates of the click in toplevel_item

		i_point        : type_item_point;
		--  the coordinates of the click in item

-- 		allowed_drag_area : type_model_rectangle := no_drag_allowed;
		--  allowed_drag_area should be modified by the callback when the event
		--  is a button_press event. it should be set to the area within which
		--  the item (and all currently selected items) can be moved. if you
		--  leave it to no_drag_allowed, the item cannot be moved.
		--
		--  this field is ignored for events other than button_press, since it
		--  makes no sense for instance to start a drag on a button release.

-- 		allow_snapping    : boolean := true;
		--  if set to false, this temporary overrides the settings from
		--  set_snap, and prevents any snapping on the grid or smart guides.
		--  it should be set at the same time that allowed_drag_area is set.
	end record;

	
end canvas_test;
