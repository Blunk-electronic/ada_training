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


package gtkada.canvas_view.canvas_test is -- a child package of gtkada.canvas_view

	type type_view is new canvas_view_record with null record;
	type type_view_ptr is access all type_view;
	
	overriding procedure draw_internal (
		--self    : not null access canvas_view_record;
		self    : not null access type_view;
		context : draw_context;
		area    : model_rectangle);



	
	type type_item is new canvas_item_record with null record;
	
	type type_item_ptr is access all type_item'class;

	overriding function bounding_box (self : not null access type_item) return item_rectangle;
	
	overriding procedure draw (
		self 	: not null access type_item;
		context	: draw_context);


end gtkada.canvas_view.canvas_test;
