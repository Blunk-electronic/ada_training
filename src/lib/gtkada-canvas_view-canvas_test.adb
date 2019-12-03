with ada.text_io;			use ada.text_io;

with gtk.main;
with gtk.window; 			use gtk.window;
with gtk.widget;  			use gtk.widget;
with gtk.box;				use gtk.box;
with gtk.button;     		use gtk.button;
with gtk.toolbar; 			use gtk.toolbar;
with gtk.tool_button;		use gtk.tool_button;
with gtk.enums;				use gtk.enums;
with gtk.gentry;			use gtk.gentry;
with gtk.combo_box_text;	use gtk.combo_box_text;
with gtk.frame;				use gtk.frame;
with gtk.scrolled_window;	use gtk.scrolled_window;
-- with gtk.bin;				use gtk.bin;

with glib;					use glib;
with glib.object;
with cairo;					use cairo;
with cairo.pattern;			use cairo.pattern;
with gtkada.canvas_view;	use gtkada.canvas_view;
with gtkada.style;     		use gtkada.style;

with pango.layout;			use pango.layout;

with ada.containers;		use ada.containers;
with ada.containers.doubly_linked_lists;

-- 
-- with Ada.Unchecked_Conversion;
-- with GNAT.Strings;                       use GNAT.Strings;
-- with Interfaces.C.Strings;               use Interfaces.C.Strings;
-- with System;
-- with Cairo.Matrix;                       use Cairo.Matrix;
-- with Cairo.Png;
-- with Cairo.PDF;                          use Cairo.PDF;
-- with Cairo.Surface;
-- with Cairo.SVG;
-- with Glib.Main;                          use Glib.Main;
-- with Glib.Properties.Creation;           use Glib.Properties.Creation;
-- with Glib.Values;                        use Glib.Values;
-- with Gdk;                                use Gdk;
-- with Gdk.Cairo;                          use Gdk.Cairo;
-- with Gdk.RGBA;                           use Gdk.RGBA;
-- with Gdk.Types.Keysyms;                  use Gdk.Types.Keysyms;
-- with Gdk.Window_Attr;                    use Gdk.Window_Attr;
-- with Gdk.Window;                         use Gdk.Window;
-- with Gtk.Accel_Group;                    use Gtk.Accel_Group;
-- with Gtk.Enums;                          use Gtk.Enums;
-- with Gtk.Handlers;                       use Gtk.Handlers;
-- with Gtk.Scrollable;                     use Gtk.Scrollable;
-- with Gtk.Style_Context;                  use Gtk.Style_Context;
-- with Gtk.Text_Buffer;                    use Gtk.Text_Buffer;
-- with Gtk.Text_Iter;                      use Gtk.Text_Iter;
-- with Gtk.Text_View;                      use Gtk.Text_View;
-- with Gtk.Widget;                         use Gtk.Widget;
-- with Gtkada.Bindings;                    use Gtkada.Bindings;
-- with Gtkada.Canvas_View.Links;           use Gtkada.Canvas_View.Links;
-- with Gtkada.Canvas_View.Objects;         use Gtkada.Canvas_View.Objects;
with Gtkada.Canvas_View.Views;           use Gtkada.Canvas_View.Views;
-- with Gtkada.Handlers;                    use Gtkada.Handlers;
-- with Gtkada.Types;                       use Gtkada.Types;
-- with Pango.Font;                         use Pango.Font;
-- with System.Storage_Elements;            use System.Storage_Elements;



package body gtkada.canvas_view.canvas_test is

	procedure draw_internal (
		self	: not null access canvas_view_record;
		context	: draw_context;
		area	: model_rectangle)
	is
		s  : item_sets.set;

		procedure draw_item
		(item : not null access abstract_item_record'class);
		procedure draw_item
		(item : not null access abstract_item_record'class) is
		begin
			--  if the item is not displayed explicitly afterwards.
			if not self.in_drag
			or else not s.contains (abstract_item (item))
			then
			translate_and_draw_item (item, context);
			end if;
		end draw_item;

		procedure add_to_set (item : not null access abstract_item_record'class);
		procedure add_to_set
		(item : not null access abstract_item_record'class) is
		begin
			s.include (abstract_item (item));
		end add_to_set;

		use item_drag_infos, item_sets;
		c  : item_drag_infos.cursor;
		c2 : item_sets.cursor;
	begin
		put_line ("draw internal");
		
		if self.model /= null then

			set_source_rgb (context.cr, 1.0, 1.0, 1.0);
			paint (context.cr);
			
			--  we must always draw the selected items and their links explicitly
			--  (since the model might not have been updated yet if we are during
			--  an automatic scrolling for instance, using a rtree).

			if self.in_drag then
			c := self.dragged_items.first;
			while has_element (c) loop
				s.include (element (c).item);  --  toplevel items
				next (c);
			end loop;
			self.model.for_each_link (add_to_set'access, from_or_to => s);
			end if;

			--  draw the active smart guides if needed
			if self.in_drag
			and then self.last_button_press.allow_snapping
			and then self.snap.smart_guides
			and then not self.dragged_items.is_empty
			then
			draw_visible_smart_guides
				(self, context, element (self.dragged_items.first).item);
			end if;

			self.model.for_each_item
			(draw_item'access, in_area => area, filter => kind_link);
			self.model.for_each_item
			(draw_item'access, in_area => area, filter => kind_item);

			if self.in_drag then
			c2 := s.first;
			while has_element (c2) loop
				translate_and_draw_item (element (c2), context);
				next (c2);
			end loop;
			end if;
		end if;
	end draw_internal;


	
	overriding function bounding_box (self : not null access type_item) return item_rectangle is 
	begin
		return (0.0, 0.0, 1000.0, 1000.0);
	end;

	overriding procedure draw (
		self 	: not null access type_item;
		context	: draw_context) is 
	begin
		put_line ("drawing ...");

		cairo.set_line_width (context.cr, 1.1);
		cairo.set_source_rgb (context.cr, gdouble (1), gdouble (1), gdouble (1));

		cairo.move_to (context.cr, 0.0, 0.0);
		cairo.line_to (context.cr, 1000.0, 1000.0);

		cairo.move_to (context.cr, 1000.0, 0.0);
		cairo.line_to (context.cr, 0.0, 1000.0);

		cairo.rectangle (context.cr, 0.0, 0.0, 1000.0, 1000.0);
		
		cairo.stroke (context.cr);
	end;

end gtkada.canvas_view.canvas_test;
