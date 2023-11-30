-- This is a simple ada program, that demonstrates gtkada
-- It shows a window with simple table with 2 rows and 2 columns.
-- The items in the table are text labels.

-- build with command "gprbuild"
-- clean up with command "gprclean"

with ada.text_io;				use ada.text_io;
with gtk.main;					use gtk.main;
with gtk.window;				use gtk.window;
with gtk.table;					use gtk.table;
with gtk.label;					use gtk.label;
-- with gtk.box;					use gtk.box;
-- with gtk.text_view;				use gtk.text_view;
-- with gtk.text_buffer;			use gtk.text_buffer;

with callbacks;					use callbacks;

procedure table is

	window		: gtk_window;
	table		: gtk_table;

	label_header 		: gtk_label;
	label_x, label_y	: gtk_label;	
	pos_x, pos_y		: gtk_label;
	-- pos_x_buf, pos_y_buf	: gtk_text_buffer;
	
begin
	init;

	gtk_new (window);
	window.set_title ("Table Demo 1");
	window.set_default_size (300, 100);
	window.on_destroy (terminate_main'access);

	gtk_new (table, rows => 2, columns => 2, homogeneous => true);
	-- gtk_new (table, rows => 2, columns => 2, homogeneous => false);

	gtk_new (label_header, "Coordinates");
	
	gtk_new (label_x, "x");
	gtk_new (pos_x, "2.3");

	gtk_new (label_y, "y");
	gtk_new (pos_y, "-412.35");


	table.attach (label_header, 
		left_attach	=> 0, right_attach	=> 2, 
		top_attach	=> 0, bottom_attach	=> 1);
	
	table.attach (label_x, 
		left_attach	=> 0, right_attach	=> 1, 
		top_attach	=> 1, bottom_attach	=> 2);

	table.attach (pos_x, 
		left_attach	=> 1, right_attach	=> 2, 
		top_attach	=> 1, bottom_attach	=> 2);

	
	table.attach (label_y, 
		left_attach	=> 0, right_attach	=> 1, 
		top_attach	=> 2, bottom_attach	=> 3);

	table.attach (pos_y, 
		left_attach	=> 1, right_attach	=> 2, 
		top_attach	=> 2, bottom_attach	=> 3);

	window.add (table);
	
	-- show the window
	window.show_all;

	-- All GTK applications must have a Gtk.Main.Main. Control ends here
	-- and waits for an event to occur (like a key press or a mouse event),
	-- until Gtk.Main.Main_Quit is called.
	gtk.main.main;
	
end table;

