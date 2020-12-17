with glib;
with gtk.main;
with gtk.window; 

with gtk.widget;

with ada.text_io;			use ada.text_io;

package body callbacks_combo_box is

	procedure terminate_main (self : access gtk_widget_record'class) is
	begin
		put_line("exiting ...");
		gtk.main.main_quit;
	end terminate_main;

	procedure selection_changed (self : access gtk_combo_box_record'class) is
		use glib;
	begin
		put_line("selection changed to" & gint'image (self.get_active));
	end selection_changed;
		
end callbacks_combo_box;
