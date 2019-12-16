with glib;					use glib;
with gtk.widget;  		--use gtk.widget;
with gtk.button;     	--use gtk.button;
with glib.object;		--use glib.object;
with gtk.gentry;
with gtkada.style;     use gtkada.style;
-- with gtk.combo_box;

with gtk.scrolled_window;	use gtk.scrolled_window;

-- with gtkada.canvas_view;				use gtkada.canvas_view;
with canvas_test;		use canvas_test;


package callbacks_4 is

	procedure terminate_main (self : access gtk.widget.gtk_widget_record'class);

-- 	scrolled				: gtk_scrolled_window;
	
	canvas : type_canvas_ptr;

-- 	model_ptr : list_canvas_model;
	scale_default : constant gdouble := 1.0;
	scale : gdouble := scale_default;

	item : type_item_ptr;
	
	p1 : gtkada.style.point := (0.0, 0.0);
	p2 : gtkada.style.point := (1000.0, 0.0);
	
	function to_string (d : in gdouble) return string;
	function to_string (p : in gtkada.style.point) return string;
	
	procedure zoom_to_fit (self : access glib.object.gobject_record'class);	
	procedure zoom_in (self : access glib.object.gobject_record'class);
	procedure zoom_out (self : access glib.object.gobject_record'class);
	procedure move_right (self : access glib.object.gobject_record'class);
	procedure move_left (self : access glib.object.gobject_record'class);	
	procedure delete (self : access glib.object.gobject_record'class);
	
	procedure echo_command_simple (self : access gtk.gentry.gtk_entry_record'class);
end;
