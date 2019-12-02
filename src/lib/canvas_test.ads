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


package canvas_test is

	-- This is the implementation of the interface abstract_item_record:
	type type_item is new abstract_item_record with record
		position : gtkada.style.point := no_position;
		visibility_threshold : gdouble := 0.0;
	end record;
	
	type type_item_ptr is access all type_item'class;


	overriding procedure set_position (
		self	: not null access type_item;
		pos		: gtkada.style.point);

	
	overriding function position (self : not null access type_item) return gtkada.style.point;
	
	overriding function bounding_box (self : not null access type_item) return item_rectangle;
	
	function is_link (self : not null access type_item) return boolean is (false);

	procedure draw (
		self 	: not null access type_item;
		context	: draw_context);

	procedure draw_as_selected (
		self    : not null access type_item;
		context : draw_context);

	procedure destroy (
		self	: not null access type_item;
		in_model: not null access canvas_model_record'class);

	function contains
		(self	: not null access type_item;
		point   : item_point;
		context : draw_context) return boolean;

	function edit_widget (
		self  	: not null access type_item;
		view  	: not null access canvas_view_record'class)
		return gtk.widget.gtk_widget;

	function parent (self : not null access type_item) return abstract_item;

	function inner_most_item (
		self     : not null access type_item;
		at_point : model_point;
		context  : draw_context)
		return abstract_item;

	function link_anchor_point (
		self   : not null access type_item;
		anchor : anchor_attachment)
		return item_point;

	function clip_line (
		self   : not null access type_item;
		p1, p2 : item_point) return item_point;

	function is_invisible (self : not null access type_item) return boolean;

	function get_visibility_threshold (self : not null access type_item) return gdouble;


	
end canvas_test;
