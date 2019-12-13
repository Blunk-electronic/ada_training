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
	
	type type_item is tagged record
		width, height : type_model_coordinate;
		--  Computed by Size_Request. Always expressed in pixels.
	end record;
	
	type type_item_ptr is access all type_item'class;

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

	procedure set_transform (
		self   : not null access type_canvas;
		cr     : cairo.cairo_context;
		item	: access type_item'class := null);
	
	procedure draw_internal (
		self    : not null access type_canvas;
		context : type_draw_context;
		area    : type_model_rectangle);

	
	procedure gtk_new (
		self	: out type_canvas_ptr;
		model	: access type_model'class := null);
	
	function canvas_get_type return glib.gtype;
	pragma convention (c, canvas_get_type);
	--  return the internal type


	
end canvas_test;
