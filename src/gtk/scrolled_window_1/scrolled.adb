-- This program demonstrates a scrolled window as shown by 
-- file scrolled.jpg.
-- The code is based on the program scrolledwindows.c
-- written by Andrew Krause in his book "Foundations of GTK+ development".

-- build with command "gprbuild"
-- clean up with command "gprclean"

with glib;						use glib;
with gtk.main;					use gtk.main;
with gtk.widget;				use gtk.widget;
with gtk.adjustment;			use gtk.adjustment;
with gtk.window;				use gtk.window;
with gtk.enums;					--use gtk.enums;
with gtk.table;					use gtk.table;
with gtk.button;				use gtk.button;
with gtk.scrolled_window;		use gtk.scrolled_window;
with gtk.box;					use gtk.box;

with ada.text_io;				use ada.text_io;
with callbacks;					use callbacks;


procedure scrolled is

	window		: gtk_window;
	table_1		: gtk_table;
	swin		: gtk_scrolled_window;
	vbox		: gtk_vbox;

	horizontal, vertical : gtk_adjustment;


	type type_buttons is array (0 .. 9, 0 .. 9) of gtk_button;
	buttons_1 : type_buttons;
	img_1 : utf8_string := "BUTTON";

begin
	init;

	-- Set up the main windwo:
	window := gtk_window_new (gtk.enums.WINDOW_TOPLEVEL);
	
	window.set_title ("Scrolled Window");
	window.set_border_width (10);
	window.set_size_request (400, 300);
	-- window.set_default_size (300, 200);
	window.on_destroy (terminate_main'access);

	-- Set up a table:
	table_1 := gtk_table_new (rows => 10, columns => 10, homogeneous => true);
	table_1.set_row_spacings (5);
	table_1.set_col_spacings (5);

	-- Fill the table with buttons (the indexes must start with zero):
	for i in 0 .. 9 loop
		for j in 0 .. 9 loop
			buttons_1 (i,j) := gtk_button_new_from_stock (img_1);
			set_relief (button => buttons_1 (i,j), relief => gtk.enums.RELIEF_NONE);
			attach_defaults (table_1, buttons_1 (i,j), guint (i), guint (i+1), guint (j), guint (j+1));
		end loop;
	end loop;

	-- Create a scrolled window:
	swin := gtk_scrolled_window_new (hadjustment => null, vadjustment => null);
	horizontal := swin.get_hadjustment;
	vertical := swin.get_vadjustment;

	-- Connect the signal "value-changed" of the scrollbars with 
	-- procedures vertical_moved and horizontal_moved. So the user
	-- can watch how the signals are emitted:
	vertical.on_value_changed (vertical_moved'access);
	horizontal.on_value_changed (horizontal_moved'access);
	
	swin.set_border_width (5);

	swin.set_policy ( -- for scrollbars
		hscrollbar_policy => gtk.enums.POLICY_AUTOMATIC, 
		vscrollbar_policy => gtk.enums.POLICY_AUTOMATIC);
		-- hscrollbar_policy => gtk.enums.POLICY_ALWAYS, 
		-- vscrollbar_policy => gtk.enums.POLICY_ALWAYS);

	-- Add table_1 as child to the scrolled window swin:
	swin.add_with_viewport (table_1); 
	
	-- Create a vbox with the scrolled window swin as child:
	vbox := gtk_vbox_new (homogeneous => true, spacing => 5);
	vbox.pack_start (child => swin); -- use defaults for the rest

	-- Add the vbox as child to the main window:
	window.add (vbox);

	window.show_all;
	gtk.main.main;
end scrolled;

