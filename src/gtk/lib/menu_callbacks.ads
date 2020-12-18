with gtk.menu_item;			use gtk.menu_item;
with gtk.menu_shell;		use gtk.menu_shell;

package menu_callbacks is

	procedure echo_item (self : access gtk_menu_item_record'class);
	
	procedure cancel_selection (self : access gtk_menu_shell_record'class);
	
end;
