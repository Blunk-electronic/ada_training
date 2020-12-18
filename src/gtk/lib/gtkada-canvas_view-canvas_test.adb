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
with gdk.rgba;
with pango.layout;			use pango.layout;

with ada.containers;		use ada.containers;
with ada.containers.doubly_linked_lists;

with gtkada.canvas_view.views;           use gtkada.canvas_view.views;

package body gtkada.canvas_view.canvas_test is

	procedure gtk_new (
		self  : out type_view_ptr;
		model : access canvas_model_record'class := null) is
	begin
		self := new type_view;
		initialize (self, model);
	end;
	
	overriding procedure draw_internal (
		self	: not null access type_view;
		context	: draw_context;
		area	: model_rectangle) is
	
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

		-- prepare draing style so that white grid dots will be drawn.
		style : drawing_style := gtk_new (stroke => gdk.rgba.white_rgba);
	begin
		put_line ("TEST: draw internal");
		
		if self.model /= null then

			-- Additional statements inserted according to advise in
			-- child package gtkada.canvas_view.views:

			-- draw a black background:
			set_source_rgb (context.cr, 0.0, 0.0, 0.0);
			paint (context.cr);

			-- draw white grid dots:
			set_grid_size (self, 100.0);
			draw_grid_dots (self, style, context, area);
			
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
		cairo.set_source_rgb (context.cr, gdouble (1), gdouble (0), gdouble (0));

		cairo.move_to (context.cr, 0.0, 0.0);
		cairo.line_to (context.cr, 1000.0, 1000.0);

		cairo.move_to (context.cr, 1000.0, 0.0);
		cairo.line_to (context.cr, 0.0, 1000.0);

		cairo.rectangle (context.cr, 0.0, 0.0, 1000.0, 1000.0);
		
		cairo.stroke (context.cr);
	end;

end gtkada.canvas_view.canvas_test;
