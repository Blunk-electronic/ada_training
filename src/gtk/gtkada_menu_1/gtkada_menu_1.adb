-- This simple demo shows how to create a menu.
-- The menu pops up at the current mouse pointer position.

with ada.text_io;		use ada.text_io;

with gtk.main;
with gtk.window; 		use gtk.window;

with gtk.menu;			use gtk.menu;
with gtk.menu_item;		use gtk.menu_item;


procedure gtkada_menu_1 is

	w : gtk_window;

	-- Initializes the main gtk stuff:
	procedure init is begin
		gtk.main.init;

		gtk_new (w);
		w.set_title ("Main Window");
		w.set_default_size (800, 600);

	end init;

	m : gtk_menu;
	i : gtk_menu_item;
	
begin
	init;
	w.show;

	-- create the menu:
	m := gtk_menu_new;

	-- create the first item and append it to the menu:
	i := gtk_menu_item_new_with_label ("item 1");
	m.append (i);

	-- show the first item
	i.show;

	-- create the second item and append it to the menu:	
	i := gtk_menu_item_new_with_label ("item 2");
	m.append (i);

	-- show the second item
	i.show;


	-- make the menu popup where the mouse is pointing at:
	m.popup;

	gtk.main.main;
	
end gtkada_menu_1;
