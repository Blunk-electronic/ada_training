with gtk.widget;
with gtk.main;
with gtk.window;
with gtk.button;
with glib.object;
with gtk.gentry;
with gtk.combo_box;
with gtkada.style;     use gtkada.style;
-- with gtk.combo_box_text;

with ada.text_io;			use ada.text_io;

package body callbacks_3 is

	procedure terminate_main (self : access gtk.widget.gtk_widget_record'class) is
	begin
		put_line ("exiting ...");
		gtk.main.main_quit;
	end;

	function to_string (d : in gdouble) return string is begin
		return gdouble'image (d);
	end;
	
	function to_string (p : in gtkada.style.point) return string is begin
		return "x/y " & to_string (p.x) & "/" & to_string (p.y);
	end;
	
	procedure zoom_to_fit (self : access glib.object.gobject_record'class) is 
		rec : model_rectangle := bounding_box (model_ptr);
	begin
		put_line ("zoom to fit ...");
		scale_to_fit (view);
		put_line (to_string (get_scale (view)));
	end;

	procedure zoom_in (self : access glib.object.gobject_record'class) is begin
		put_line ("zooming in ...");
		scale := get_scale (view);
		scale := scale + 0.1;
		set_scale (view, scale);
		put_line (to_string (get_scale (view)));
	end;

	procedure zoom_out (self : access glib.object.gobject_record'class) is begin
		put_line ("zooming out ...");
		scale := get_scale (view);
		if scale >= 0.0 then
			scale := scale - 0.1;
			set_scale (view, scale);
		end if;
		put_line (to_string (get_scale (view)));
	end;

	procedure move_right (self : access glib.object.gobject_record'class) is begin
		put_line ("moving right ...");
		set_position (item, p2);
		refresh_layout (model_ptr);
	end;

	procedure move_left (self : access glib.object.gobject_record'class) is begin
		put_line ("moving left ...");
		set_position (item, p1);
		refresh_layout (model_ptr);
	end;

	procedure delete (self : access glib.object.gobject_record'class) is begin
		put_line ("deleting ...");

		model_ptr.remove (item);
		-- model_ptr.clear; -- removes all items

		refresh_layout (model_ptr);
	end;
	
	procedure echo_command_simple (self : access gtk.gentry.gtk_entry_record'class) is 
		use gtk.gentry;
	begin
		put_line (get_text (self));
	end;

end;
