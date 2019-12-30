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
-- and is concerned with only the most relevant code.
-- For the sake for simplicity we do not use abstract types, interfaces
-- or private types.

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

	-- The items to be displayed inside the model have a coordinate, a place
	-- in the drawing. For understanding here an example:
	--  If you draw a circle at position 40/50 mm on a sheet of paper then this
	--  is the model coordinate. The circle is always at this place independed
	--  of scale, zoom or the visible area of your drawing.

	-- For the real world coordinates we define millimeters:
	type type_millimeters is delta 0.01 range -100_000_000.00 .. 100_000_000.00;
	for type_millimeters'small use 0.01;
 
	-- The items placed in the model (or on the sheet) use millimeters.
	subtype type_model_coordinate is type_millimeters;
	
	-- A point at the model (or on the sheet):
	type type_model_point is record
		x, y : type_model_coordinate := type_model_coordinate'first;
	end record;
	
	-- Indicates that the item did not get assigned a proper position:
	no_position : constant type_model_point := (
						x	=> type_model_coordinate'first,
						y	=> type_model_coordinate'first);

		
-- ITEM:
	-- Coordinates relative to the position of the item are used when drawing an item.
	-- Since they are real world coordinates we use millimeters.
	subtype type_item_coordinate is type_millimeters;
	
	type type_item_point is record
		x, y : type_item_coordinate := type_item_coordinate'first;
	end record;
	
	-- This is a simple item. In our case it is a rectangle with a 
	-- position in the model (or on the sheet):
	type type_item is tagged record
		position : type_model_point := no_position;
		
		visibility_threshold : gdouble := 0.0; -- gdouble is a real floating-point type (see glib.ads) 

		c1 : type_item_point := (250.0, 200.0);
		c2 : type_item_point := (750.0, 200.0);

		c10 : type_item_point := (0.0, 0.0);
		c11 : type_item_point := (1000.0, 0.0);
		c12 : type_item_point := (0.0, 1000.0);
		c13 : type_item_point := (1000.0, 1000.0);
		-- In this simple example c13 is the point that defines the greatest x and y 
		-- size of the item. On computing the size of the item 
		-- (see procedure size_request) this point is required. 
		
		width, height : type_model_coordinate; -- computed by Size_Request
	end record;

	-- We need pointers to all types derived from the base type_item.
	type type_item_ptr is access all type_item'class;

	function get_visibility_threshold (self : not null access type_item) return gdouble;



	-- The so called "bounding box" of an item is a rectangle where the item fits in.
	-- It is used to calculate the area required for an item.
	type type_item_rectangle is record
		x, y			: type_item_coordinate; -- position of bounding box
		width, height	: type_item_coordinate; -- size of bounding box
	end record;

	function bounding_box (self : not null access type_item) return type_item_rectangle;




	
	-- Access values of items are stored in a simple list:
	package pac_items is new doubly_linked_lists (type_item_ptr);

	

-- MODEL:
	
	-- To stay with the example of the drawing sheet (see above) the model is the sheet
	-- where items are placed at.
	-- The model consists of a list of item access values.
	-- NOTE: The model stores pointers, not the items themselves ! The items are located in the heap.
	type type_model is new glib.object.gobject_record with record
		items	: pac_items.list;
		layout	: pango.layout.pango_layout;
	end record;

	-- The type to access the model:
	type type_model_ptr is access all type_model;
	




	-- A rectangular area of the model:
	type type_model_rectangle is record
		x, y			: type_model_coordinate; -- position
		width, height	: type_model_coordinate; -- size
	end record;

	no_rectangle : constant type_model_rectangle := (0.0, 0.0, 0.0, 0.0);




	-- In order to process items contained in the model this procedure 
	-- should be used. The procedure itself calls procedure "callback"
	-- for each item.
	-- If a certain region of the model via "in_area" provided, only the
	-- items in that area are processed.
	procedure for_each_item (
		self    	: not null access type_model;
		callback	: not null access procedure (item : not null access type_item'class);
		in_area		: type_model_rectangle := no_rectangle);

	
	-- Initializes the internal data so that the model can send signals:
	procedure init (self : not null access type_model'class);

	-- Creates a new model (or a drawing sheet according to the example above):
	procedure gtk_new (self : out type_model_ptr);

	-- This signal is emitted by the model whenever items are added, moved, resized, ...
	signal_layout_changed : constant glib.signal_name := "layout_changed";
	


	
-- VIEW / CANVAS

	-- The view (or canvas) displays a certain region of the model (or the sheet) 
	-- depending on scrolling or zoom.
	type type_view is new gtk.widget.gtk_widget_record with record
		model 		: type_model_ptr;

		-- The upper left corner of the visible area has its initial value at 0/0.
		-- NOTE: This has nothing to do with the upper left corner of the
		-- drawing sheet. topleft is not a constant and is changed on by procedure
		-- set_scale or by procedure scale_to_fit.
		topleft   	: type_model_point := (0.0, 0.0);
		
		scale     	: gdouble := 1.0; -- gdouble is a real floating-point type (see glib.ads)
		grid_size 	: type_model_coordinate := 20.0;
		
		layout		: pango.layout.pango_layout; -- CS for displaying text. not used yet

		-- Required for the scrollbars:
		hadj, vadj	: gtk.adjustment.gtk_adjustment;

		-- connections to model signals
		id_layout_changed : gtk.handlers.handler_id := (gtk.handlers.null_handler_id, null);

		scale_to_fit_requested : gdouble := 0.0; -- gdouble is a real floating-point type (see glib.ads)
		scale_to_fit_area : type_model_rectangle;
	end record;

	-- The pointer to the canvas/view:
	type type_view_ptr is access all type_view'class;




	
	procedure set_adjustment_values (self : not null access type_view'class);
	
	no_point : constant type_model_point := (
					x	=> type_model_coordinate'first,
					y	=> type_model_coordinate'first);

	function get_scale (self : not null access type_view) return gdouble;
	
	procedure set_scale (
		self     : not null access type_view;
		scale    : gdouble := 1.0;
		preserve : type_model_point := no_point);
	-- Changes the scaling factor for self.
	-- this also scrolls the view so that either preserve or the current center
	-- of the view remains at the same location in the widget, as if the user
	-- was zooming towards that specific point.

	
	function get_visible_area (self : not null access type_view) return type_model_rectangle;
	-- Return the area of the model (or the sheet) that is currently displayed in the view.
	-- This is in model coordinates (since the canvas coordinates are always
	-- from (0,0) to (self.get_allocation_width, self.get_allocation_height).

	signal_viewport_changed : constant glib.signal_name := "viewport_changed";
	-- This signal is emitted whenever the view is zoomed or scrolled.


	-- To stay with the example of a drawing sheet, the view coordinates are the 
	-- coordinates of items on the screen and are expressed in pixels.
	-- They change when the operators zooms or scrolls.
	subtype type_view_coordinate is gdouble; -- gdouble is a real floating-point type (see glib.ads)

	-- The point inside the view.
	type type_view_point is record
		x, y : type_view_coordinate;
	end record;

	-- A rectangular regions of the view:
	type type_view_rectangle is record
		x, y, width, height : type_view_coordinate;
	end record;

	-- Converts the given area of the view to a model rectangle:
	function view_to_model (
		self   : not null access type_view;
		rect   : in type_view_rectangle) -- position and size are in pixels
		return type_model_rectangle;

	-- Converts the given point in the model to a point in the view.
	function model_to_view (
		self   : not null access type_view;
		p      : in type_model_point) -- position x/y given as a float type
		return type_view_point;
	
	-- Converts the given area of the model to a view rectangle:	
	function model_to_view (
		self   : not null access type_view;
		rect   : in type_model_rectangle) -- position x/y and size given as a float type
		return type_view_rectangle;
	
	--  The number of blank pixels on each sides of the view. This avoids having
	--  items displays exactly next to the border of the view.
	view_margin : constant type_view_coordinate := 20.0;


	-- The cairo context to perform the actual drawing.
	-- NOTE: The final drawing is performed in the view (hence in view coordinates):
	type type_draw_context is record
		cr     : cairo.cairo_context := cairo.null_context;
		layout : pango.layout.pango_layout := null; -- CS for displaying text. not used yet
		view   : type_view_ptr := null;
	end record;

	-- Sets the width and height of the item according to the greatest x and y
	-- points used by the item.
	procedure size_request (self : not null access type_item);

	-- This procedure should be called every time items are moved, added or removed.
	-- Call this procedure after having created after a view has been created for the model.
	procedure refresh_layout (
		self        : not null access type_model;
		send_signal : boolean := true); -- sends "layout_changed" signal when true
	
	-- Draws the item on the given cairo context.
	-- A transformation matrix has already been applied to Cr, so that all
	-- drawing should be done in item-coordinates for Self, so that (0,0) is
	-- the top-left corner of Self's bounding box.
	-- Do not call this procedure directly. Instead, call
	-- Translate_And_Draw_Item below:
	procedure draw (
		self 	: not null access type_item;
		context	: type_draw_context);

	-- Translate the transformation matrix and draw the item.
	-- This procedure should be used instead of calling Draw directly.
	procedure translate_and_draw_item (
		self          : not null access type_item'class;
		context       : type_draw_context);

	-- Set the transformation matrix for the current settings (scrolling and zooming).
	--
	-- The effect is that any drawing on this context should now be done using
	-- the model coordinates, which will automatically be converted to the
	-- view coordinates internally.
	--
	-- If Item is specified, all drawing becomes relative to that item
	-- instead of the position of the top-left corner of the view. All drawing
	-- to this context must then be done in item_coordinates, which will
	-- automatically be converted to view coordinates internally.
	--
	-- This procedure does not need to be called directly in general, since the
	-- context passed to the Draw primitive of the item has already been set
	-- up appropriately.
	--
	-- The default coordinates follow the industry standard of having y
	-- increase downwards. This is sometimes unusual for mathematically-
	-- oriented people. One solution is to override this procedure in your
	-- own view, and call Cairo.Set_Scale as in:
	--      procedure Set_Transform (Self, Cr) is
	--          Set_Transform (Canvas_View_Record (Self.all)'Access, Cr);
	--          Cairo.Set_Scale (Cr, 1.0, -1.0);
	-- which will make y increase upwards instead.
	procedure set_transform (
		self	: not null access type_view;
		cr		: cairo.cairo_context;
		item	: access type_item'class := null);

	procedure set_grid_size (
		self : not null access type_view'class;
		size : type_model_coordinate := 30.0);

	procedure draw_grid_dots (
		self    : not null access type_view'class;
		style   : gtkada.style.drawing_style;
		context : type_draw_context;
		area    : type_model_rectangle);

	-- Redraw either the whole view, or a specific part of it only.
	-- The transformation matrix has already been set on the context.
	procedure draw_internal (
		self    : not null access type_view;
		context : type_draw_context;
		area    : type_model_rectangle);

	function position (self : not null access type_item) return type_model_point;
	
	procedure set_position (
		self	: not null access type_item;
		pos		: type_model_point);
	
	procedure gtk_new (
		self	: out type_view_ptr;
		model	: access type_model'class := null);

	procedure add (
		self : not null access type_model;
		item : not null access type_item'class);

	procedure remove (
		self : not null access type_model;
		item : not null access type_item'class);
	
	procedure scale_to_fit (
		self      : not null access type_view;
		rect      : type_model_rectangle := no_rectangle;
		min_scale : gdouble := 1.0 / 4.0;
		max_scale : gdouble := 4.0);

	
	function view_get_type return glib.gtype;
	pragma convention (c, view_get_type);
	--  return the internal type

	
	function view_to_model (
		self   : not null access type_view;
		p      : type_view_point) return type_model_point;

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
