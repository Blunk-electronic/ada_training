------------------------------------------------------------------------------
--                  GtkAda - Test and Education Program                     --
--                                                                          --
--      Bases on the package gtkada.canvas_view written by                  --
--      E. Briot, J. Brobecker and A. Charlet, AdaCore                      --
--                                                                          --
--      Modified and simplyfied by Mario Blunk, Blunk electronic            --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
------------------------------------------------------------------------------

--   For correct displaying set tab width in your editor to 4.

--   The two letters "CS" indicate a "construction site" where things are not
--   finished yet or intended for the future.

--   Please send your questions and comments to:
--
--   info@blunk-electronic.de
--   or visit <http://www.blunk-electronic.de> for more contact data
--
--   history of changes:
--

-- Rationale: Aims to help users understanding programming with gtkada,
-- especially creating a canvas with items displayed on it.
-- The code is reduced to a minimum so that the newcomer is not overtaxed
-- and sees only the most relevant code.

with gtk.main;
with gtk.window; 			use gtk.window;
with gtk.widget;  			use gtk.widget;
with gtk.box;				use gtk.box;
with gtk.button;     		use gtk.button;
with gtk.handlers;			use gtk.handlers;
with gtk.toolbar; 			use gtk.toolbar;
with gtk.tool_button;		use gtk.tool_button;
with gtk.enums;				use gtk.enums;
with gtk.gentry;			use gtk.gentry;
with gtk.combo_box_text;	use gtk.combo_box_text;
with gtk.frame;				use gtk.frame;
with gtk.scrolled_window;	use gtk.scrolled_window;
with gtk.adjustment;		use gtk.adjustment;

with gdk;
with gdk.types;

with glib;					use glib;
with glib.object;			use glib.object;
with glib.values;			use glib.values;
with cairo;					use cairo;
with cairo.pattern;			use cairo.pattern;
with gtkada.style;     		use gtkada.style;

with pango.layout;			use pango.layout;

with ada.containers;		use ada.containers;
with ada.containers.doubly_linked_lists;


package canvas_test is

	subtype type_model_coordinate is gdouble;

	no_position : constant gtkada.style.point := (gdouble'first, gdouble'first);
	
	type type_item is tagged record
		position : gtkada.style.point := no_position;
		
		visibility_threshold : gdouble := 0.0;
		
		width, height : type_model_coordinate;
		--  Computed by Size_Request. Always expressed in pixels.
	end record;
	
	type type_item_ptr is access all type_item'class;

	function get_visibility_threshold (self : not null access type_item) return gdouble;
	
	subtype type_item_coordinate is gdouble;
	
	type type_item_rectangle is record
		x, y, width, height : type_item_coordinate;
	end record;

	function bounding_box (self : not null access type_item) return type_item_rectangle;

	subtype type_item_point is gtkada.style.point;

	
	package pac_items is new doubly_linked_lists (type_item_ptr);
	
	type type_model is new glib.object.gobject_record with record
		layout	: pango.layout.pango_layout;
		items	: pac_items.list;
	end record;
	
	type type_model_ptr is access all type_model;
	


	type type_model_point is record
		x, y : type_model_coordinate;
	end record;
	
	type type_model_rectangle is record
		x, y, width, height : type_model_coordinate;
	end record;

	no_rectangle : constant type_model_rectangle := (0.0, 0.0, 0.0, 0.0);

	procedure for_each_item (
		self    	: not null access type_model;
		callback	: not null access procedure (item : not null access type_item'class);
		in_area		: type_model_rectangle := no_rectangle);

	
	procedure init (self : not null access type_model'class);
   --  initialize the internal data so that signals can be sent.

	
	procedure gtk_new (self : out type_model_ptr);

	signal_layout_changed : constant glib.signal_name := "layout_changed";
	
	type type_canvas is new gtk.widget.gtk_widget_record with record
		model 		: type_model_ptr;
		topleft   	: type_model_point := (0.0, 0.0);
		scale     	: gdouble := 1.0;
		grid_size 	: type_model_coordinate := 20.0;
		layout		: pango.layout.pango_layout;
		hadj, vadj	: gtk.adjustment.gtk_adjustment;

		--  connections to model signals
		id_layout_changed : gtk.handlers.handler_id := (gtk.handlers.null_handler_id, null);

		scale_to_fit_requested : gdouble := 0.0;
		scale_to_fit_area : type_model_rectangle;
	end record;
	
	type type_canvas_ptr is access all type_canvas'class;

	procedure set_adjustment_values (self : not null access type_canvas'class);
	
	no_point : constant type_model_point := (gdouble'first, gdouble'first);

	function get_scale (self : not null access type_canvas) return gdouble;
	
	procedure set_scale (
		self     : not null access type_canvas;
		scale    : gdouble := 1.0;
		preserve : type_model_point := no_point);
	--  changes the scaling factor for self.
	--  this also scrolls the view so that either preserve or the current center
	--  of the view remains at the same location in the widget, as if the user
	--  was zooming towards that specific point.
	--  see also gtkada.canvas_view.views.animate_scale for a way to do this
	--  change via an animation.

	
	function get_visible_area (self : not null access type_canvas) return type_model_rectangle;
	--  return the area of the model that is currently displayed in the view.
	--  this is in model coordinates (since the canvas coordinates are always
	--  from (0,0) to (self.get_allocation_width, self.get_allocation_height).

	signal_viewport_changed : constant glib.signal_name := "viewport_changed";
	-- This signal is emitted whenever the view is zoomed or scrolled.


	
	subtype type_view_coordinate is gdouble;

	type type_view_point is record
		x, y : type_view_coordinate;
	end record;
	
	type type_view_rectangle is record
		x, y, width, height : type_view_coordinate;
	end record;

	function view_to_model (
		self   : not null access type_canvas;
		rect   : type_view_rectangle) 
		return type_model_rectangle;

	function model_to_view (
		self   : not null access type_canvas;
		rect   : type_model_rectangle) return type_view_rectangle;

	
	view_margin : constant type_view_coordinate := 20.0;
	--  The number of blank pixels on each sides of the view. This avoids having
	--  items displays exactly next to the border of the view.


	type type_draw_context is record
		cr     : cairo.cairo_context := cairo.null_context;
		layout : pango.layout.pango_layout := null;
		view   : type_canvas_ptr := null;
	end record;
	--  context to perform the actual drawing


	procedure refresh_layout (
		self    : not null access type_item;
		context : type_draw_context);

	procedure refresh_layout (
		self        : not null access type_model;
		send_signal : boolean := true);
	
	procedure size_request (self : not null access type_item);

	procedure draw (
		self 	: not null access type_item;
		context	: type_draw_context);
	
	procedure set_transform (
		self   : not null access type_canvas;
		cr     : cairo.cairo_context;
		item	: access type_item'class := null);

	procedure set_grid_size (
		self : not null access type_canvas'class;
		size : type_model_coordinate := 30.0);

	procedure draw_grid_dots (
		self    : not null access type_canvas'class;
		style   : gtkada.style.drawing_style;
		context : type_draw_context;
		area    : type_model_rectangle);
	
	procedure draw_internal (
		self    : not null access type_canvas;
		context : type_draw_context;
		area    : type_model_rectangle);

	function position (self : not null access type_item) return gtkada.style.point;
	
	procedure set_position (
		self  : not null access type_item;
		pos   : gtkada.style.point);
	
	procedure gtk_new (
		self	: out type_canvas_ptr;
		model	: access type_model'class := null);

	procedure add (
		self : not null access type_model;
		item : not null access type_item'class);

	procedure remove (
		self : not null access type_model;
		item : not null access type_item'class);
	
	procedure scale_to_fit (
		self      : not null access type_canvas;
		rect      : type_model_rectangle := no_rectangle;
		min_scale : gdouble := 1.0 / 4.0;
		max_scale : gdouble := 4.0;
		duration  : standard.duration := 0.0);

	
	function view_get_type return glib.gtype;
	pragma convention (c, view_get_type);
	--  return the internal type

	
	subtype type_window_coordinate is gdouble;
	
	type type_window_point is record
		x, y : type_window_coordinate;
	end record;

	function view_to_model (
		self   : not null access type_canvas;
		p      : type_view_point) return type_model_point;
	
	function window_to_model (
		self   : not null access type_canvas;
		p      : type_window_point) return type_model_point;

	no_item_point : constant type_item_point := (gdouble'first, gdouble'first);

	function model_to_item (
		item   : not null access type_item'class;
		p      : type_model_rectangle) return type_item_rectangle;

	function model_to_item (
		item   : not null access type_item'class;
		p      : type_model_point) return type_item_point;

end canvas_test;

-- Soli Deo Gloria

-- For God so loved the world that he gave 
-- his one and only Son, that whoever believes in him 
-- shall not perish but have eternal life.
-- The Bible, John 3.16
