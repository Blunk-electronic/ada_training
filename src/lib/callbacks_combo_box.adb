with glib;
with glib.values;
with gtk.main;
with gtk.widget;
with gtk.window; 
with gtk.tree_model;			
with gtk.list_store;

with ada.text_io;				use ada.text_io;

package body callbacks_combo_box is

	procedure terminate_main (self : access gtk_widget_record'class) is
	begin
		put_line("exiting ...");
		gtk.main.main_quit;
	end terminate_main;

	procedure selection_changed (combo : access gtk_combo_box_record'class) is
		use glib;
		use gtk.tree_model;
		use gtk.list_store;

		-- Get the model and active iter from the combo box:
		model : constant gtk_tree_model := combo.get_model;
		iter : constant gtk_tree_iter := combo.get_active_iter;

		item_text : glib.values.gvalue;
	begin
		put_line ("selected entry no:" & gint'image (combo.get_active));
		-- NOTE: The entries are numbered from 0 to N.

		-- Get the actual text of the entry:
		gtk.tree_model.get_value (model, iter, 0, item_text);

		-- Output the text of the entry:
		put_line ("item is: " & glib.values.get_string (item_text));
		new_line;
		
	end selection_changed;
		
end callbacks_combo_box;
