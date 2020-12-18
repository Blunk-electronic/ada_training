-- This is a simple ada program, that demonstrates gtkada
-- It shows a window with a combo box.
-- It requires to have package gtkada installed.

-- build with command "gprbuild"
-- clean up with command "gprclean"

with glib;						--use glib;

with gtk.main;					use gtk.main;
with gtk.window;				use gtk.window;
with gtk.box;					use gtk.box;
with gtk.combo_box;				use gtk.combo_box;
with gtk.cell_renderer_text;	use gtk.cell_renderer_text;
with gtk.cell_layout;        	use gtk.cell_layout;
with gtk.list_store;			use gtk.list_store;
with gtk.tree_model;			use gtk.tree_model;

with ada.text_io;				use ada.text_io;

with callbacks_combo_box;	--use callbacks_combo_box;


procedure text_view_1 is

	window	: gtk.window.gtk_window;
	box		: gtk_vbox;
	combo	: gtk_combo_box;

	storage_model : gtk_list_store;

	-- An entry consists of just a single column:
	column_0 : constant := 0;

	-- The single column is to contain strings:
	entry_structure : glib.gtype_array := (column_0 => glib.gtype_string);

	iter : gtk_tree_iter;
	
	render : gtk_cell_renderer_text;
begin
	init;

	gtk_new (window);
	window.set_title ("Combo Box Demo");
	window.set_default_size (300, 100);

	window.on_destroy (callbacks_combo_box.terminate_main'access);

	gtk_new_vbox (box, homogeneous => false);
	window.add (box);


	
	-- Create the storage model:
	gtk_new (list_store => storage_model, types => (entry_structure));
	
	-- Insert the entries in the storage model:
	-- NOTE: The entries are numbered from 0 to N.
	for choice in 1 .. 3 loop
		storage_model.append (iter);
		gtk.list_store.set (storage_model, iter, column_0, "item" & integer'image (choice));
	end loop;

	storage_model.append (iter);
	gtk.list_store.set (storage_model, iter, column_0, "dummy item A");

	storage_model.append (iter);
	gtk.list_store.set (storage_model, iter, column_0, "another useless item");

	

	-- Create the combo box:
	gtk.combo_box.gtk_new_with_model (
		combo_box	=> combo,
		model		=> +storage_model); -- ?

	-- Set the item to be selected per default
	combo.set_active (0);

	combo.on_changed (callbacks_combo_box.selection_changed'access);
	
	-- Put the combo box in the main box:
	pack_start (box, combo, expand => false);


	-- The purpose of this stuff is unclear, but it
	-- is required to make the entries visible:
	gtk_new (render);
	pack_start (combo, render, expand => true);
	add_attribute (combo, render, "markup", column_0);

	

	
	-- show the window
	window.show_all;

	-- All GTK applications must have a Gtk.Main.Main. Control ends here
	-- and waits for an event to occur (like a key press or a mouse event),
	-- until Gtk.Main.Main_Quit is called.
	gtk.main.main;
	
end text_view_1;

