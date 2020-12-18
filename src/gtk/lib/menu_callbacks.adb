with ada.text_io;			use ada.text_io;

package body menu_callbacks is

	procedure echo_item (self : access gtk_menu_item_record'class) is
	begin
		put_line (self.get_label & " selected");
	end;

	procedure cancel_selection (self : access gtk_menu_shell_record'class) is
	begin
		put_line ("cancelled");
	end cancel_selection;

end;
