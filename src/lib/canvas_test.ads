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

	type type_model is new glib.object.gobject_record with null record;
	type type_model_ptr is access all type_model;

	procedure init (self : not null access type_model'class);
   --  initialize the internal data so that signals can be sent.

	
	procedure gtk_new (self : out type_model_ptr);
	
	type type_canvas is new gtk.widget.gtk_widget_record with record
		model : type_model_ptr;
		hadj, vadj : gtk.adjustment.gtk_adjustment;
	end record;
	
	type type_canvas_ptr is access all type_canvas;


	
	procedure gtk_new (
		self	: out type_canvas_ptr;
		model	: access type_model'class := null);
	
	function canvas_get_type return glib.gtype;
-- 	function view_get_type return glib.gtype;
	pragma convention (c, canvas_get_type);
-- 	pragma convention (c, view_get_type);
	--  return the internal type
	
end canvas_test;
