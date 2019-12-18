------------------------------------------------------------------------------
--                  GtkAda - Test and Education Program                     --
--                                                                          --
--                Written by Mario Blunk, Blunk electronic                  --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
------------------------------------------------------------------------------

--   For correct displaying set tab width in your editor to 4.

--   The two letters "CS" indicate a "construction site" where things are not
--   finished yet or intended for the future.

--   Please send your questions and comments to:
--
--   info@blunk-electronic.de
--   or visit <http://www.blunk-electronic.de> for more contact data
--
--   history of changes:
--

-- This is a simple ada program, that demonstrates gtkada.
-- It draws a canvas, black drawing background, with a red square on it.

-- Rationale: Aims to help users understanding programming with gtkada.

with gtk.main;
with ada.text_io;			use ada.text_io;
with canvas_test;			use canvas_test;

package body callbacks_4 is

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
	begin
		put_line ("zoom to fit ...");
		scale_to_fit (canvas);
		put_line (to_string (get_scale (canvas)));
	end;

	procedure zoom_in (self : access glib.object.gobject_record'class) is begin
		put_line ("zooming in ...");
		scale := get_scale (canvas);
		scale := scale + 0.1;
		set_scale (canvas, scale);
		put_line (to_string (get_scale (canvas)));
	end;

	procedure zoom_out (self : access glib.object.gobject_record'class) is begin
		put_line ("zooming out ...");
		scale := get_scale (canvas);
		if scale >= 0.0 then
			scale := scale - 0.1;
			set_scale (canvas, scale);
		end if;
		put_line (to_string (get_scale (canvas)));
	end;

	procedure move_right (self : access glib.object.gobject_record'class) is begin
		put_line ("moving right ...");
		set_position (item, p2);
		refresh_layout (model);
	end;

	procedure move_left (self : access glib.object.gobject_record'class) is begin
		put_line ("moving left ...");
		set_position (item, p1);
		refresh_layout (model);
	end;

	procedure delete (self : access glib.object.gobject_record'class) is begin
		put_line ("deleting ...");

		model.remove (item);
		--model.items.clear; -- removes all items

		refresh_layout (model);
	end;
	
	procedure echo_command_simple (self : access gtk.gentry.gtk_entry_record'class) is 
		use gtk.gentry;
	begin
		put_line (get_text (self));
	end;

end;

-- Soli Deo Gloria

-- For God so loved the world that he gave 
-- his one and only Son, that whoever believes in him 
-- shall not perish but have eternal life.
-- The Bible, John 3.16
