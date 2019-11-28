with gtk.widget;
with gtk.main;
with gtk.window;
with gtk.button;
with glib.object;
with gtk.gentry;
with gtk.combo_box;
-- with gtk.combo_box_text;

with ada.text_io;			use ada.text_io;

package body callbacks_3 is

	procedure terminate_main (self : access gtk.widget.gtk_widget_record'class) is
	begin
		put_line ("exiting ...");
		gtk.main.main_quit;
	end;

	procedure write_message_off (self : access gtk.button.gtk_button_record'class) is
	begin
		put_line ("The machine is being shutdown ...");
		
		-- do things requried to shut down the machine ...
	end;

	procedure write_message_on (self : access gtk.button.gtk_button_record'class) is
	begin
		put_line ("The machine is being powered up ...");
		
		-- do things requried to power up the machine ...
	end;

	
-- 	procedure write_message_up (self : access glib.object.gobject_record'class) is begin
-- 		put_line ("The blinds are moving up ...");
-- 	end;
	
	procedure zoom_to_fit (self : access glib.object.gobject_record'class) is 
		rec : model_rectangle := bounding_box (model_ptr);
	begin
		put_line ("zoom to fit ...");
		scale := 1.0;
		set_scale (view, scale);
	end;


	procedure zoom_in (self : access glib.object.gobject_record'class) is begin
		put_line ("zooming in ...");
		scale := scale + 0.1;
		set_scale (view, scale);
	end;

	procedure zoom_out (self : access glib.object.gobject_record'class) is begin
		put_line ("zooming out ...");
		scale := scale - 0.1;
		set_scale (view, scale);
	end;


	
	procedure echo_command_simple (self : access gtk.gentry.gtk_entry_record'class) is 
		use gtk.gentry;
	begin
		put_line (get_text (self));
	end;

-- 	procedure echo_command_advanced (self : access gtk.combo_box.gtk_combo_box_record'class) is 
-- 		use gtk.combo_box_text;
-- 	begin
-- 		null;
-- 		put_line (get_active_text (self));
-- 	end;


end;
