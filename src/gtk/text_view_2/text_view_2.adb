-- This is a simple ada program, that demonstrates
-- the text view widget inside a scrolled window.

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
with gtk.viewport;				use gtk.viewport;
with gtk.box;					use gtk.box;
-- with gtk.text_view;				use gtk.text_view;

with ada.text_io;				use ada.text_io;

with callbacks_text_view_2;		use callbacks_text_view_2;


procedure text_view_2 is

	window				: gtk_window;
	table_1, table_2	: gtk_table;
	swin				: gtk_scrolled_window;
	viewport			: gtk_viewport;
	vbox				: gtk_vbox;

	horizonal, vertical : gtk_adjustment;


	type type_buttons is array (1 .. 10, 1 .. 10) of gtk_button;
	buttons_1, buttons_2 : type_buttons;
	img : utf8_string := "CLOSE"; -- CS ?

begin
	init;

	-- Set up the main windwo:
	window := gtk_window_new (gtk.enums.WINDOW_TOPLEVEL);
	
	window.set_title ("Scrolled Windows & Viewports");
	window.set_border_width (10);
	--window.set_size_request (500, 400);
	-- window.set_size_request (300, 200);
	window.on_destroy (terminate_main'access);

	-- Set up the two tables:
	table_1 := gtk_table_new (rows => 10, columns => 10, homogeneous => true);
	table_2 := gtk_table_new (rows => 10, columns => 10, homogeneous => true);

	table_1.set_row_spacings (5);
	table_2.set_row_spacings (5);
	table_1.set_col_spacings (5);
	table_2.set_col_spacings (5);

	-- Fill the two tables with buttons:
	for i in 1 .. 10 loop
		for j in 1 .. 10 loop
			buttons_1 (i,j) := gtk_button_new_from_stock (img);
			buttons_2 (i,j) := gtk_button_new_from_stock (img);

			set_relief (button => buttons_1 (i,j), relief => gtk.enums.RELIEF_NONE);

			attach_defaults (table_1, buttons_1 (i,j), guint (i), guint (i+1), guint (j), guint (j+1));
			attach_defaults (table_2, buttons_2 (i,j), guint (i), guint (i+1), guint (j), guint (j+1));
		end loop;
	end loop;

	-- Create a scrolled window:
	swin := gtk_scrolled_window_new (hadjustment => null, vadjustment => null);
	horizonal := swin.get_hadjustment;
	vertical := swin.get_vadjustment;

	-- Create a viewport:
	viewport := gtk_viewport_new (horizonal, vertical);
	
	swin.set_border_width (5);
	viewport.set_border_width (5);

	swin.set_policy (
		-- hscrollbar_policy => gtk.enums.POLICY_AUTOMATIC, 
		-- vscrollbar_policy => gtk.enums.POLICY_AUTOMATIC);
		hscrollbar_policy => gtk.enums.POLICY_ALWAYS, 
		vscrollbar_policy => gtk.enums.POLICY_ALWAYS);

						
	swin.add_with_viewport (table_1);
	viewport.add (table_2);

	
	-- Create a vbox:
	vbox := gtk_vbox_new (homogeneous => true, spacing => 5);
	
	vbox.pack_start (child => viewport); -- use defaults for the rest
	vbox.pack_start (child => swin); -- use defaults for the rest

	window.add (vbox);

	-- show the window
	window.show_all;

	gtk.main.main;
	
end text_view_2;

