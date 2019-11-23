------------------------------------------------------------------------------
--                  GtkAda - Ada95 binding for Gtk+/Gnome                   --
--                                                                          --
--      Copyright (C) 1998-2000 E. Briot, J. Brobecker and A. Charlet       --
--                     Copyright (C) 1998-2016, AdaCore                     --
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

--  <description>
--  This package is a rewrite of Gtkada.Canvas, with hopefully more
--  capabilities and a cleaner API.
--
--  It provides a drawing area (canvas) on which items can be displayed and
--  linked together. It also supports interactive manipulation of those
--  items.
--
--  This package is organized around the concept of Model-View-Controller:
--    - The model is an item that gives access to all the items contained
--      in the canvas, although it need not necessarily own them. A default
--      model implementation is provided which indeed stores the items
--      internally, but it is possible to create a model which is a simple
--      wrapper around an application-specific API that would already have the
--      list of items.
--
--    - The view is in charge of representing the model, or a subset of it. It
--      is possible to have multiple views for a single model, each displaying
--      a different subset or a different part of the whole canvas.
--      When a view is put inside a Gtk_Scrolled_Window, it automatically
--      supports scrolling either via the scrollbars, or directly with the
--      mouse wheel or touchpad.
--
--    - The controller provides the user interaction in the canvas, and will
--      change the view and model properties when the user performs actions.
--
--  A view does not draw any background (image, grid,...). This is because
--  there are simply too many ways application want to take advantage of the
--  background. Instead, you should override the Draw_Internal primitive and
--  take advantage (optionally) of some of the helps in
--  Gtkada.Canvas_View.Views, which among other things provide ways to draw
--  grids.
--
--  Likewise, a view does not handle events by default (except for scrolling
--  when it is put in a Gtk_Scrolled_Window). This is also because applications
--  want to do widely different things (for some, clicking in the background
--  should open a menu, whereas others will want to let the user scroll by
--  dragging the mouse in the background -- likewise when clicking on items
--  for instance).
--
--  Differences with Gtkada.Canvas
--  ==============================
--
--  This package is organized around the concept of Model-View-Controller,
--  which provides a much more flexible approach. There is for instance no
--  need to duplicate the items in memory if you already have them available
--  somewhere else in your application.
--
--  Various settings that were set on an Interactive_Canvas (like the font for
--  annotations, arrow sizes,...) are now configured on each item or link
--  separately, which provides much more flexibility in what this canvas can
--  display.
--
--  The support for items is much richer: via a number of new primitive
--  operations, it is possible to control with more details the behavior of
--  items and where links should be attached to them.
--  More importantly, this package provides a ready-to-use set of predefined
--  items (rectangles, circles, text, polygons,...) which can be composited
--  and have automatic size computation. This makes it easier than before to
--  have an item that contains, for instance, a list of text fields, since
--  there is no need any more to compute the size of the text explicitly.
--
--  This package systematically use a Gdouble for coordinates (in any of the
--  coordinate systems), instead of the mix of Gint, Gdouble and Gfloat that
--  the Gtkada.Canvas is using. In fact, most of the time applications will
--  only have to deal with the item coordinate system (see below), and never
--  with the view coordinate system.
--
--  The behavior of snap-to-grid is different: whereas in Gtkada.Canvas it
--  forces items to always be aligned with the grid (with no way to have items
--  not aligned), the Canvas_View's effect is more subtle: basically, when an
--  item is moved closed enough to the grid, it will be aligned to the grid.
--  But if it is far from any grid line, you can drop it anywhere.
--  Snapping also takes into account all four edges of items, not just their
--  topleft corner.
--
--  User interaction
--  ================
--
--  By default, limited user interaction is supported:
--     * When a view is added to a Gtk_Scrolled_Window, scrolling is
--       automatically supported (it is handled by the scrolled window).
--       Users can use the mouse wheel to scroll vertically, shift and the
--       mouse wheel to scroll horizontally, or use the touchpad to navigate
--       (in general with multiple fingers).
--
--  But of course it supports much more advanced interactions, like clicking
--  on items, moving them with the mouse or keyboard,...
--
--  For this, you need to connect to the "item_event" signal, and either
--  directly handle the signal (a simple click for instance), or set some
--  data in the details parameters, to enable dragging items or the background
--  of the canvas (for scrolling). The package Gtkada.Canvas_View.Views
--  provides a number of precoded behaviors.
--
--  When dragging items, the view will scroll automatically if the mouse is
--  going outside of the visible area. Scrolling will continue while the mouse
--  stays there, even if the user does not move the mouse.
--
--  The following has not been backported yet:
--  ==========================================
--
--  Items are selected automatically when they are clicked. If Control is
--  pressed at the same time, multiple items can be selected.
--  If the background is clicked (and control is not pressed), then all items
--  are unselected.
--  Pressing and dragging the mouse in the backgroudn draws a virtual box on
--  the screen. All the items fully included in this box when it is released
--  will be selected (this will replace the current selection if Control was
--  not pressed).
--
--  </description>
--  <group>Drawing</group>
--  <testgtk>create_canvas_view.adb</testgtk>

pragma Ada_2012;

with Ada.Containers.Doubly_Linked_Lists;
-- private with Ada.Containers.Hashed_Maps;
-- with Ada.Containers.Hashed_Sets;
-- with Ada.Numerics.Generic_Elementary_Functions; use Ada.Numerics;
-- private with Ada.Unchecked_Deallocation;
-- private with GNAT.Strings;
with Cairo;
-- with Gdk.Event;        use Gdk.Event;
-- with Gdk.Pixbuf;       use Gdk.Pixbuf;
-- with Gdk.Types;        use Gdk.Types;
-- private with Glib.Main;
with Glib;             use Glib;
with Glib.Object;      use Glib.Object;
with Gtk.Adjustment;   use Gtk.Adjustment;
-- with Gtk.Handlers;
with Gtk.Bin;          use Gtk.Bin;
with Gtk.Widget;
with Gtkada.Style;     use Gtkada.Style;
-- with Pango.Layout;     use Pango.Layout;

package canvas_test is

	type Canvas_View_Record is new Gtk.Widget.Gtk_Widget_Record with private;
	type Canvas_View is access all Canvas_View_Record'Class;

	subtype Model_Coordinate  is Gdouble;
	subtype View_Coordinate   is Gdouble;
	
	type Model_Rectangle  is record
		X, Y, Width, Height : Model_Coordinate;
	end record;

	type View_Rectangle   is record
		X, Y, Width, Height : View_Coordinate;
	end record;

	type View_Point  is record
		X, Y : View_Coordinate;
	end record;

	type Model_Point is record
		X, Y : Model_Coordinate;
	end record;

	
	function View_To_Model
		(Self   : not null access Canvas_View_Record;
		 Rect   : View_Rectangle) return Model_Rectangle;
	
	function View_To_Model
		(Self   : not null access Canvas_View_Record;
		P      : View_Point) return Model_Point;

	
	function Get_Visible_Area
		(Self : not null access Canvas_View_Record)
		return Model_Rectangle;
	--  Return the area of the model that is currently displayed in the view.
	--  This is in model coordinates (since the canvas coordinates are always
	--  from (0,0) to (Self.Get_Allocation_Width, Self.Get_Allocation_Height).

	
	
	type Canvas_Model_Record is abstract new Glib.Object.GObject_Record with private;
	type Canvas_Model is access all Canvas_Model_Record'Class;

-- 	function Bounding_Box
-- 		(Self   : not null access Canvas_Model_Record;
-- 		Margin : Model_Coordinate := 0.0)
-- 		return Model_Rectangle;
-- 	--  Returns the rectangle that encompasses all the items in the model.
-- 	--  This is used by views to compute the maximum area that should be made
-- 	--  visible.
-- 	--  An extra margin is added to each side of the box.
-- 	--  The default implementation is not efficient, since it will iterate all
-- 	--  items one by one to compute the rectangle. No caching is done.

	
	procedure Gtk_New (
		Self  : out Canvas_View;
		Model : access Canvas_Model_Record'Class := null);

	procedure Initialize (
		Self  : not null access Canvas_View_Record'Class;
		Model : access Canvas_Model_Record'Class := null);

	
	type List_Canvas_Model_Record is new Canvas_Model_Record with private;
	type List_Canvas_Model is access all List_Canvas_Model_Record'Class;

	procedure Initialize
		(Self : not null access Canvas_Model_Record'Class);


	
	type Abstract_Item_Record is interface;
	type Abstract_Item is access all Abstract_Item_Record'Class;

	function Bounding_Box
		(Self : not null access Abstract_Item_Record)
		return Item_Rectangle is abstract;
	--  Returns the area occupied by the item.
	--  Any drawing for the item, including shadows for instance, must be
	--  within this area.
	--  This bounding box is always returned in the item's own coordinate
	--  system, so that it is not necessary to pay attention to the current
	--  scaling factor or rotation for the item, its parents or the canvas view.

	
	package Items_Lists is new Ada.Containers.Doubly_Linked_Lists (Abstract_Item);

	type Canvas_Item_Record is abstract new Abstract_Item_Record with private;
	type Canvas_Item is access all Canvas_Item_Record'Class;
   
	No_Position : constant Gtkada.Style.Point := (Gdouble'First, Gdouble'First);
	
	procedure dummy;


	
private
	
	type Canvas_View_Record is new Gtk.Bin.Gtk_Bin_Record with record
      Model     : Canvas_Model;
      Topleft   : Model_Point := (0.0, 0.0);
      Scale     : Gdouble := 1.0;
	  --       Grid_Size : Model_Coordinate := 20.0;
		Hadj, Vadj : Gtk.Adjustment.Gtk_Adjustment;
	end record;

	type Canvas_Model_Record is abstract new Glib.Object.GObject_Record with null record;
-- 		Layout    : Pango.Layout.Pango_Layout;

-- 		Selection : Item_Sets.Set;
-- 		Mode      : Selection_Mode := Selection_Single;
-- 	end record;
	
	type List_Canvas_Model_Record is new Canvas_Model_Record with record
		Items : Items_Lists.List;
	end record;

	type Canvas_Item_Record is abstract new Abstract_Item_Record with record
		Position : Gtkada.Style.Point := No_Position;
	end record;


	
end canvas_test;
