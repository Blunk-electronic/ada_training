------------------------------------------------------------------------------
--                  GtkAda - Test and Education Program                     --
--                                                                          --
--      Modified and witten by Mario Blunk, Blunk electronic                --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
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
with glib.object;			use glib.object;

with ada.text_io;			use ada.text_io;

with callbacks_4;			use callbacks_4;
with canvas_test;			use canvas_test;

procedure gtkada_9 is

	window 					: gtk_window;
	box_back				: gtk_box;
	box_left, box_right		: gtk_box;
	box_console				: gtk_box;
	box_drawing				: gtk_box;
	
	button_zoom_to_fit					: gtk_tool_button;
	button_zoom_in, button_zoom_out		: gtk_tool_button;
	button_move_right, button_move_left	: gtk_tool_button;
	button_delete						: gtk_tool_button;
	
	toolbar					: gtk_toolbar;
	console					: gtk_entry;
	frame					: gtk_frame;
	scrolled				: gtk_scrolled_window;
	
	procedure init is begin
		gtk.main.init;

		gtk_new (window);
		window.set_title ("Some Title");
		window.set_default_size (800, 600);

		-- background box
		gtk_new_hbox (box_back);
		set_spacing (box_back, 10);
		add (window, box_back);

		-- left box
		gtk_new_hbox (box_left);
		set_spacing (box_left, 10);
		pack_start (box_back, box_left, expand => false);

		-- right box
		gtk_new_vbox (box_right);
		set_spacing (box_right, 10);
		add (box_back, box_right);

		-- toolbar on the left
		gtk_new (toolbar);
		set_orientation (toolbar, orientation_vertical);
		pack_start (box_left, toolbar, expand => false);
		
		-- Create another button and place it in the toolbar:
		gtk.tool_button.gtk_new (button_zoom_to_fit, label => "FIT");
		insert (toolbar, button_zoom_to_fit);
		button_zoom_to_fit.on_clicked (callbacks_4.zoom_to_fit'access, toolbar);

		-- Create a button and place it in the toolbar:
		gtk.tool_button.gtk_new (button_zoom_in, label => "IN");
		insert (toolbar, button_zoom_in);
		button_zoom_in.on_clicked (callbacks_4.zoom_in'access, toolbar);

		-- Create another button and place it in the toolbar:
		gtk.tool_button.gtk_new (button_zoom_out, label => "OUT");
		insert (toolbar, button_zoom_out);
		button_zoom_out.on_clicked (callbacks_4.zoom_out'access, toolbar);

		-- Create another button and place it in the toolbar:
		gtk.tool_button.gtk_new (button_move_right, label => "MOVE RIGHT");
		insert (toolbar, button_move_right);
		button_move_right.on_clicked (callbacks_4.move_right'access, toolbar);
		
		gtk.tool_button.gtk_new (button_move_left, label => "MOVE LEFT");
		insert (toolbar, button_move_left);
		button_move_left.on_clicked (callbacks_4.move_left'access, toolbar);

		gtk.tool_button.gtk_new (button_delete, label => "DELETE");
		insert (toolbar, button_delete);
		button_delete.on_clicked (callbacks_4.delete'access, toolbar);

		
		-- box for console on the right top
		gtk_new_vbox (box_console);
		set_spacing (box_console, 10);
		pack_start (box_right, box_console, expand => false);

		-- a simple text entry
		gtk_new (console);
		set_text (console, "cmd: ");
		pack_start (box_console, console, expand => false);
		console.on_activate (callbacks_4.echo_command_simple'access); -- on hitting enter

		-- drawing area on the right bottom
		gtk_new_hbox (box_drawing);
		set_spacing (box_drawing, 10);
		add (box_right, box_drawing);

		gtk_new (frame);
		pack_start (box_drawing, frame);

		gtk_new (scrolled);
		set_policy (scrolled, policy_automatic, policy_automatic);
		add (frame, scrolled);

	end;
	
begin
	init;

	-- model
	gtk_new (model);
	initialize (model);
	
	-- canvas
	gtk_new (canvas, model);
	add (scrolled, canvas);
	
	item := new type_item;
	
-- 	put_line (to_string (position (item)));
	add (model, item);
	set_position (item, p1);
	refresh_layout (model);
	
	scale_to_fit (canvas);
-- 	put_line (to_string (get_scale (canvas)));
	
	window.on_destroy (callbacks_4.terminate_main'access);

	window.show_all;
	gtk.main.main;
end;


-- Soli Deo Gloria

-- For God so loved the world that he gave 
-- his one and only Son, that whoever believes in him 
-- shall not perish but have eternal life.
-- The Bible, John 3.16
