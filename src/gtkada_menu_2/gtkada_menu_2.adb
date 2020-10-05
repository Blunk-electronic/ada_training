-- This simple demo shows how to create a menu.
-- The menu pops up at the current mouse pointer position.

with ada.text_io;		use ada.text_io;

with gtk.main;
with gtk.window; 		use gtk.window;

with gtk.menu;			use gtk.menu;
with gtk.menu_item;		use gtk.menu_item;

with callbacks;
with menu_callbacks;

procedure gtkada_menu_2 is

	w : gtk_window;

	-- Initializes the main gtk stuff:
	procedure init is begin
		gtk.main.init;

		gtk_new (w);
		w.set_title ("Main Window");
		w.set_default_size (800, 600);

		w.on_destroy (callbacks.terminate_main'access);
		
	end init;

	m : gtk_menu;
	i : gtk_menu_item;
	
begin
	init;
	w.show;

	-- Create the menu and connect the "on_cancel" signal
	-- with the procedure cancel_selection:
	m := gtk_menu_new;
	m.on_cancel (menu_callbacks.cancel_selection'access);
	
	-- Create the first item, connect it with a subprogram,
	-- append it to the menu and show the item:
	i := gtk_menu_item_new_with_label ("item 1");

	-- connect the item with a procedure that outputs the
	-- name of the item:
	i.on_activate (menu_callbacks.echo_item'access);
	
	m.append (i);
	i.show;

	-- Likewise with the second item:
	i := gtk_menu_item_new_with_label ("item 2");
	i.on_activate (menu_callbacks.echo_item'access);
	m.append (i);
	i.show;


	-- make the menu popup where the mouse is pointing at:
	m.popup;

	gtk.main.main;
	
end gtkada_menu_2;
