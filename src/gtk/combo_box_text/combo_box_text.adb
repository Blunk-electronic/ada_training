-- This is a simple ada program, that demonstrates gtkada
-- It shows a window with a combo box text.
-- It requires to have package gtkada installed.

-- build with command "gprbuild"
-- clean up with command "gprclean"

with gtk.main;					use gtk.main;
with gtk.window;				use gtk.window;
with gtk.box;					use gtk.box;
with gtk.combo_box_text;		use gtk.combo_box_text;
with gtk.gentry;				use gtk.gentry;

with ada.text_io;				use ada.text_io;

with callbacks_combo_box_text;	--use callbacks_combo_box_text;


procedure combo_box_text is

	window	: gtk.window.gtk_window;
	box		: gtk_vbox;
	combo	: gtk_combo_box_text;

begin
	init;

	gtk_new (window);
	window.set_title ("Combo Box Text Demo");
	window.set_default_size (300, 100);
	window.on_destroy (callbacks_combo_box_text.terminate_main'access);

	gtk_new_vbox (box);
	window.add (box);


	

	-- Create the combo box and put in in the box
	gtk.combo_box_text.gtk_new_with_entry (combo);
	pack_start (box, combo, expand => false);

	-- Try these statements in order to set the width
	-- of the entry. Find more in the specs of package gtk.gentry:

	-- To set a maximim of ten characters to be entered:
	--gtk_entry (combo.get_child).set_max_length (10);

	-- To set a minimum width for five characters to be visible.
	-- NOTE; The effect is visible when you try to adjust the
	-- width of the main window to a minimum.
	--gtk_entry (combo.get_child).set_width_chars (5);



	
	-- Connect the child of combo (which is a gentry) with
	-- the procedure that outputs the entered text:
	gtk_entry (combo.get_child).on_activate (callbacks_combo_box_text.some_text_entered'access);	


	
	-- show the window
	window.show_all;

	-- All GTK applications must have a Gtk.Main.Main. Control ends here
	-- and waits for an event to occur (like a key press or a mouse event),
	-- until Gtk.Main.Main_Quit is called.
	gtk.main.main;
	
end combo_box_text;
