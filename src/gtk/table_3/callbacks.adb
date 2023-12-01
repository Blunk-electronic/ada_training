with ada.text_io;				use ada.text_io;
with glib;						use glib;
with gdk.types;
with gdk.types.keysyms;
with gtk.main;					use gtk.main;

with ada.numerics;
with ada.numerics.generic_elementary_functions;

package body callbacks is

	
	procedure update_table_content is 
		package pac_float_functions is new 
			ada.numerics.generic_elementary_functions (float);

		use pac_float_functions;
			
		dx : float := abs (float (x));
		dy : float := abs (float (y));
		dabs : type_distance;
	begin
		-- x-coordinate:
		pos_x_buf.set_text (type_distance'image (x));
		pos_x.set_buffer (pos_x_buf);

		-- y-coordinate:
		pos_y_buf.set_text (type_distance'image (y));
		pos_y.set_buffer (pos_y_buf);

		-- Compute the absolute distance from
		-- origin (0;0) to point (x;y) and display it
		-- in the table:
		dabs := type_distance (sqrt (dx ** 2.0 + dy ** 2.0));
		total_buf.set_text (type_distance'image (dabs));
		total.set_buffer (total_buf);
	end update_table_content;

	
	
	procedure terminate_main (
		window : access gtk_widget_record'class) 
	is begin
		put_line("exiting ...");
		gtk.main.main_quit;
	end terminate_main;




	function cb_key_pressed (
		window	: access gtk_widget_record'class;
		event	: gdk_event_key)
		return boolean
	is
		event_handled : boolean := true;

		use gdk.types;		
		use gdk.types.keysyms;
		
-- 		key_ctrl	: gdk_modifier_type := event.state and control_mask;
-- 		key_shift	: gdk_modifier_type := event.state and shift_mask;
		key			: gdk_key_type := event.keyval;

	begin
		-- Output the the gdk_key_type (which is
		-- just a number (see gdk.types und gdk.types.keysyms)):
		-- put_line ("cb_key_pressed: " & gdk_key_type'image (event.keyval));

		case key is
			when GDK_Right =>
				put_line ("right");
				x := x * 10.0;
				-- x := x + 0.01;

			when GDK_Left =>
				put_line ("left");
				x := x / 10.0;
				-- x := x - 0.5;
				if x = 0.0 then
					x := 1.0;
				end if;

			when GDK_Up =>
				put_line ("up");
				y := y * 10.0;

			when GDK_Down =>
				put_line ("down");
				y := y / 10.0;
				if y = 0.0 then
					y := 1.0;
				end if;

			when others =>
				null;
		end case;
		

		update_table_content;
		
		return event_handled;
	end cb_key_pressed;
	
end callbacks;

