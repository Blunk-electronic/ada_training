------------------------------------------------------------------------------
--                  GtkAda - Test and Education Program                     --
--                                                                          --
--      Modified and written by Mario Blunk, Blunk electronic               --
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
-- It draws a canvas, black drawing background, a yellow rectangle, 
-- a red X and a green horzontal line.

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

	-- The window is composed of several boxes that contain boxes with things in them.
	-- All these things are called "widgets". Their type is basically an access (or a pointer).
	-- A widget is a button, a text box, a frame, in short something the operator
	-- can click on or something that displays stuff.
	
	window 					: gtk_window; -- This is an access/pointer to the actual window.
	box_back				: gtk_box; -- This is an access/pointer to the actual box.
	box_left, box_right		: gtk_box;
	box_console				: gtk_box;
	box_drawing				: gtk_box;

	-- We will have some buttons:
	button_zoom_to_fit					: gtk_tool_button; -- This is an access/pointer to the actual button.
	button_zoom_in, button_zoom_out		: gtk_tool_button;
	button_move_right, button_move_left	: gtk_tool_button;
	button_delete						: gtk_tool_button;

	-- We will have a toolbar, a console, a frame and a scrolled window:
	toolbar					: gtk_toolbar; -- This is an access/pointer to the actual toolbar.
	console					: gtk_entry;
	frame					: gtk_frame;
	scrolled				: gtk_scrolled_window;
	
	procedure init is begin
		gtk.main.init; -- initialize the main gtk stuff

		gtk_new (window); -- create the main window (where pointer "window" is pointing at)
		window.set_title ("Test canvas");
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



		
		-- Create a button and place it in the toolbar:
		gtk.tool_button.gtk_new (button_zoom_to_fit, label => "FIT");
		insert (toolbar, button_zoom_to_fit);

		-- If the operator clicks the button
		-- call the procedure zoom_to_fit in package callbacks_4:
		button_zoom_to_fit.on_clicked (callbacks_4.zoom_to_fit'access, toolbar);



		
		-- Create a button and place it in the toolbar:
		gtk.tool_button.gtk_new (button_zoom_in, label => "IN");
		insert (toolbar, button_zoom_in);

		-- If the operator clicks the button
		-- call the procedure zoom_in in package callbacks_4:
		button_zoom_in.on_clicked (callbacks_4.zoom_in'access, toolbar);



		
		-- Create another button and place it in the toolbar:
		gtk.tool_button.gtk_new (button_zoom_out, label => "OUT");
		insert (toolbar, button_zoom_out);

		-- If the operator clicks the button
		-- call the procedure zoom_out in package callbacks_4:
		button_zoom_out.on_clicked (callbacks_4.zoom_out'access, toolbar);


		
		
		-- Create another button and place it in the toolbar:
		gtk.tool_button.gtk_new (button_move_right, label => "MOVE RIGHT");
		insert (toolbar, button_move_right);
		
		-- If the operator clicks the button
		-- call the procedure move_right in package callbacks_4:		
		button_move_right.on_clicked (callbacks_4.move_right'access, toolbar);


		
		
		gtk.tool_button.gtk_new (button_move_left, label => "MOVE LEFT");
		insert (toolbar, button_move_left);

		-- If the operator clicks the button
		-- call the procedure move_left in package callbacks_4:
		button_move_left.on_clicked (callbacks_4.move_left'access, toolbar);


		
		
		gtk.tool_button.gtk_new (button_delete, label => "DELETE");
		insert (toolbar, button_delete);

		-- If the operator clicks the button
		-- call the procedure delete in package callbacks_4:
		button_delete.on_clicked (callbacks_4.delete'access, toolbar);



		
		-- box for console on the right top
		gtk_new_vbox (box_console);
		set_spacing (box_console, 10);
		pack_start (box_right, box_console, expand => false);

		-- a simple text entry
		gtk_new (console);
		set_text (console, "cmd: ");
		pack_start (box_console, console, expand => false);

		-- If the operator hits enter after typing text in the console,
		-- call the procedure echo_command_simple in package callbacks_4:
		console.on_activate (callbacks_4.echo_command_simple'access); -- on hitting enter



		
		-- drawing area on the right bottom
		gtk_new_hbox (box_drawing);
		set_spacing (box_drawing, 10);
		add (box_right, box_drawing);

		-- frame inside the drawing box
		gtk_new (frame);
		pack_start (box_drawing, frame);

		-- scrolled window inside the frame
		gtk_new (scrolled);
		set_policy (scrolled, policy_automatic, policy_automatic);
		add (frame, scrolled);

	end;
	
begin
	init; -- set up the main window

	-- create a so called model for the items to be displayed:
	gtk_new (model); -- model is declared in callbacks_4
	initialize (model);
	
	-- create a canvas that uses the model
	gtk_new (canvas, model); -- canvas is declared in callbacks_4
	add (scrolled, canvas); -- place the canvas in the scrolled window

	-- create a new item. The item is created in the memory. 
	-- The model in turn stores not the item but the access to it.
	-- So each newly created item advances the access "item".
	-- Since the items are created in the memory they must later be cleared from
	-- memory when the operator wishes to delete them.
	item := new type_item; -- item is declared in callbacks_4

	-- add the item access value to the model
	-- put_line (to_string (position (item)));
	add (model, item); 

	-- Set position of the item. 
	-- The procedure set_position changes the coordinate of the item
	-- by modifying the object where "item" is pointing at. 
	-- After changing the item position the layout must be refreshed.
	set_position (item, p1); -- point p1 is declared callbacks_4.
	refresh_layout (model);

	-- Zoom so that the item is fully visible.
	scale_to_fit (canvas);
-- 	put_line (to_string (get_scale (canvas)));


	-- If the operator wishes to terminate the program (by clicking X)
	-- the procedure terminate_main (in callbacks_4) is to be called.
	window.on_destroy (callbacks_4.terminate_main'access);

	-- Display all the widgets on the screen:
	window.show_all;

	-- Start the main gtk loop. This is a loop that permanently draws the widgets and
	-- samples them for possible signals sent.
	gtk.main.main;
end;


-- Soli Deo Gloria

-- For God so loved the world that he gave 
-- his one and only Son, that whoever believes in him 
-- shall not perish but have eternal life.
-- The Bible, John 3.16
