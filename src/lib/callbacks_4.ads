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


with glib;				use glib;
with gtk.widget;  		--use gtk.widget;
with gtk.button;     	--use gtk.button;
with glib.object;		--use glib.object;
with gtk.gentry;
with gtkada.style;		use gtkada.style;

with canvas_test;		use canvas_test;


package callbacks_4 is

	-- Here are the pointers/access variables to the canvas, model and item.
	-- They must be declared here because the so called "callbacks" (see below)
	-- use them.
	canvas	: type_view_ptr;
	model	: type_model_ptr;
	item	: type_item_ptr;
	
	scale_default : constant gdouble := 1.0;
	scale : gdouble := scale_default;
	
	-- Points where the item is to be placed:
	p1 : type_model_point := (0.0, 0.0); -- initial position
	p2 : type_model_point := (1000.0, 0.0); -- when moved to the right

	
	function to_string (d : in gdouble) return string;
	function to_string (p : in gtkada.style.point) return string;

	-- Callbacks:
	-- These procedures are called when the operator clicks buttons or terminates the program.
	-- See procedure init in gtkada_9.adb where the connections are made.
	procedure terminate_main (self : access gtk.widget.gtk_widget_record'class);
	procedure zoom_to_fit (self : access glib.object.gobject_record'class);	
	procedure zoom_in (self : access glib.object.gobject_record'class);
	procedure zoom_out (self : access glib.object.gobject_record'class);
	procedure move_right (self : access glib.object.gobject_record'class);
	procedure move_left (self : access glib.object.gobject_record'class);	
	procedure delete (self : access glib.object.gobject_record'class);
	procedure echo_command_simple (self : access gtk.gentry.gtk_entry_record'class);
end;

-- Soli Deo Gloria

-- For God so loved the world that he gave 
-- his one and only Son, that whoever believes in him 
-- shall not perish but have eternal life.
-- The Bible, John 3.16
