-- This ada program shows a window with a table 
-- with 3 rows and 2 columns. It uses textviews
-- for in the second column to display x, y coordinates
-- and total distance.
-- With the cursor-keys (right, left, up, down) the 
-- coordinates can be changed.
-- The coordinates are right justified. The table has 
-- a fixed width regardless of the size of the  
-- surrounding main window.

-- build with command "gprbuild"
-- clean up with command "gprclean"

with ada.text_io;				use ada.text_io;
with gdk.event;					use gdk.event;
with glib;						use glib;
with gtk.main;					use gtk.main;
with gtk.window;				use gtk.window;
with gtk.separator;				use gtk.separator;
with gtk.table;					use gtk.table;
with gtk.label;					use gtk.label;
with gtk.box;					use gtk.box;
with gtk.text_view;				use gtk.text_view;
with gtk.text_buffer;			use gtk.text_buffer;
with gtk.enums;					use gtk.enums;
with gtk.misc;					use gtk.misc;

with callbacks;					use callbacks;

procedure table is

	window			: gtk_window;
	box_h			: gtk_hbox;
	box_v1, box_v2	: gtk_vbox; -- left and right box inside box_h
	table			: gtk_table; -- the table inside the left box

	separator		: gtk_separator;
	
	label_header 				: gtk_label;
	label_x, label_y, label_tot	: gtk_label;	
	
	
begin
	init;

	gtk_new (window);
	window.set_title ("Table Demo 3");
	window.set_default_size (400, 100);
	window.set_border_width (10);
	window.on_destroy (terminate_main'access);

	gtk_new_hbox (box_h);
	gtk_new_vbox (box_v1);
	gtk_new_vbox (box_v2);

	-- Make the main window responding to the keyboard:
	window.add_events (key_press_mask);
	window.on_key_press_event (cb_key_pressed'access);
	
	-- The left vbox shall not change its width when the 
	-- main window is resized:
	box_h.pack_start (box_v1, expand => false);
	-- box_h.pack_start (box_v1, expand => true);

	-- Place a separator between the left and right
	-- vertical box:
	separator := gtk_separator_new (ORIENTATION_VERTICAL);
	box_h.pack_start (separator, expand => false);

	-- The right vbox shall expand upon resizing the main window:
	box_h.pack_start (box_v2);

	-- CREATE THE TABLE:
	-- gtk_new (table, rows => 3, columns => 2, homogeneous => true);
	gtk_new (table, rows => 3, columns => 2, homogeneous => false);
	-- table.set_col_spacings (50);

	-- The table shall not expand downward:
	box_v1.pack_start (table, expand => false);
	------------------------------------------------------------------

	
	-- Create a text label to be placed in the table
	-- as a headline:
	gtk_new (label_header, "Coordinates");

	
	-- X-COORDINATE:
	gtk_new (label_x, "x:"); -- create a text label

	-- The label shall be aligned in the column.
	-- The discussion at:
	-- <https://stackoverflow.com/questions/26345989/gtk-how-to-align-a-label-to-the-left-in-a-table>
	-- gave the solution. See also package gtk.misc for details:
	label_x.set_alignment (0.0, 0.0);	
	gtk_new (pos_x); -- create a text view vor the value
	-- A minimum width must be set for the text.
	-- Setting the size request is one way. The height is
	-- not affected, therefore the value -1:
	pos_x.set_size_request (pos_field_width_min, -1);
	-- See also discussion at:
	-- <https://stackoverflow.com/questions/24412859/gtk-how-can-the-size-of-a-textview-be-set-manually>
	-- for a way to achieve this using a tag.

	gtk_new (pos_x_buf); -- create a text buffer
	pos_x.set_justification (JUSTIFY_RIGHT); -- align the value left
	pos_x.set_editable (false); -- the value is not editable
	pos_x.set_cursor_visible (false); -- do not show a cursor

	
	-- Y-COORDINATE:
	-- See comments on x-coordinates.
	gtk_new (label_y, "y:");
	label_y.set_alignment (0.0, 0.0);
	gtk_new (pos_y);
	pos_y.set_size_request (pos_field_width_min, -1);
	gtk_new (pos_y_buf);
	pos_y.set_justification (JUSTIFY_RIGHT);
	pos_y.set_editable (false);
	pos_y.set_cursor_visible (false);


	-- TOTAL-DISTANCE:
	-- See comments on x-coordinates.
	gtk_new (label_tot, "abs:");
	label_tot.set_alignment (0.0, 0.0);
	gtk_new (total);
	total.set_size_request (pos_field_width_min, -1);
	gtk_new (total_buf);
	total.set_justification (JUSTIFY_RIGHT);
	total.set_editable (false);
	total.set_cursor_visible (false);

	------------------------------------------------------------------

	
	-- Put the items in the table:
	table.attach (label_header, 
		left_attach	=> 0, right_attach	=> 2, 
		top_attach	=> 0, bottom_attach	=> 1);

	-- x-coordinate:
	table.attach (label_x, 
		left_attach	=> 0, right_attach	=> 1, 
		top_attach	=> 1, bottom_attach	=> 2);

	table.attach (pos_x, 
		left_attach	=> 1, right_attach	=> 2, 
		top_attach	=> 1, bottom_attach	=> 2);

	-- y-coordinate:
	table.attach (label_y, 
		left_attach	=> 0, right_attach	=> 1, 
		top_attach	=> 2, bottom_attach	=> 3);

	table.attach (pos_y, 
		left_attach	=> 1, right_attach	=> 2, 
		top_attach	=> 2, bottom_attach	=> 3);

	-- absolute distance:
	table.attach (label_tot, 
		left_attach	=> 0, right_attach	=> 1, 
		top_attach	=> 3, bottom_attach	=> 4
		-- xoptions => EXPAND --FILL
		);

	table.attach (total, 
		left_attach	=> 1, right_attach	=> 2, 
		top_attach	=> 3, bottom_attach	=> 4);


	------------------------------------------------------------------
	
	window.add (box_h);
	window.show_all;

	
	update_table_content;

	
	-- All GTK applications must have a Gtk.Main.Main. Control ends here
	-- and waits for an event to occur (like a key press or a mouse event),
	-- until Gtk.Main.Main_Quit is called.
	gtk.main.main;
	
end table;

