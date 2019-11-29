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


package body canvas_test is

	overriding procedure set_position (
		self	: not null access type_item;
		pos		: gtkada.style.point) is
	begin
		self.position := pos;
	end;
	
	overriding function position (self : not null access type_item) return gtkada.style.point is
	begin
		return self.position;
	end;

	function bounding_box (self : not null access type_item) return item_rectangle is 
	begin
		return (0.0, 0.0, 1000.0, 1000.0);
	end;

	procedure draw (
		self 	: not null access type_item;
		context	: draw_context) is 
	begin
		put_line ("drawing ...");

		cairo.set_line_width (context.cr, 1.1);
		cairo.set_source_rgb (context.cr, gdouble (1), gdouble (1), gdouble (1));

		cairo.move_to (context.cr, 0.0, 0.0);
		cairo.line_to (context.cr, 1000.0, 1000.0);

		cairo.move_to (context.cr, 1000.0, 0.0);
		cairo.line_to (context.cr, 0.0, 1000.0);

		cairo.rectangle (context.cr, 0.0, 0.0, 1000.0, 1000.0);
		
		cairo.stroke (context.cr);
	end;

	procedure draw_as_selected (
		self    : not null access type_item;
		context : draw_context) is
	begin
		null;
	end;

	function contains
		(self	: not null access type_item;
		point   : item_point;
		context : draw_context) return boolean is
	begin
		return false;
	end;

	function edit_widget (
		self  : not null access type_item;
		view  : not null access canvas_view_record'class)
		return gtk.widget.gtk_widget is
		w : gtk.widget.gtk_widget;
	begin
		return w;
	end;

	function parent (self : not null access type_item) return abstract_item is
		a : abstract_item;
	begin
		return a;
	end;

	function inner_most_item (
		self     : not null access type_item;
		at_point : model_point;
		context  : draw_context)
		return abstract_item is
		a : abstract_item;
	begin
		return a;
	end;
		
	function link_anchor_point (
		self   : not null access type_item;
		anchor : anchor_attachment)
		return item_point is
		p : item_point;
	begin
		return p;
	end;
	
	function clip_line (
		self   : not null access type_item;
		p1, p2 : item_point) return item_point is
		p : item_point;
	begin
		return p;
	end;
		
	function is_invisible (self : not null access type_item)
		return boolean is 
	begin
		return false;
	end;

	function get_visibility_threshold (self : not null access type_item) return gdouble is
	begin
		return self.visibility_threshold;
	end;


	
end canvas_test;
