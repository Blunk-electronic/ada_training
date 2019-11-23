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

-- with Ada.Unchecked_Conversion;
-- with GNAT.Strings;                       use GNAT.Strings;
-- with Interfaces.C.Strings;               use Interfaces.C.Strings;
with System;
-- with Cairo;                              use Cairo;
-- with Cairo.Matrix;                       use Cairo.Matrix;
-- with Cairo.Pattern;                      use Cairo.Pattern;
-- with Cairo.Png;
-- with Cairo.PDF;                          use Cairo.PDF;
-- with Cairo.Surface;
-- with Cairo.SVG;
-- with Glib.Main;                          use Glib.Main;
with Glib.Properties.Creation;           	use Glib.Properties.Creation;
with Glib.Values;                        use Glib.Values;
-- with Gdk;                                use Gdk;
-- with Gdk.Cairo;                          use Gdk.Cairo;
-- with Gdk.RGBA;                           use Gdk.RGBA;
-- with Gdk.Types.Keysyms;                  use Gdk.Types.Keysyms;
-- with Gdk.Window_Attr;                    use Gdk.Window_Attr;
-- with Gdk.Window;                         use Gdk.Window;
-- with Gtk.Accel_Group;                    use Gtk.Accel_Group;
-- with Gtk.Enums;                          use Gtk.Enums;
-- with Gtk.Handlers;                       use Gtk.Handlers;
with Gtk.Scrollable;                     use Gtk.Scrollable;
-- with Gtk.Style_Context;                  use Gtk.Style_Context;
-- with Gtk.Text_Buffer;                    use Gtk.Text_Buffer;
-- with Gtk.Text_Iter;                      use Gtk.Text_Iter;
-- with Gtk.Text_View;                      use Gtk.Text_View;
-- with Gtk.Widget;                         use Gtk.Widget;
-- with Gtkada.Bindings;                    use Gtkada.Bindings;
-- with Gtkada.Canvas_View.Links;           use Gtkada.Canvas_View.Links;
-- with Gtkada.Canvas_View.Objects;         use Gtkada.Canvas_View.Objects;
-- with Gtkada.Canvas_View.Views;           use Gtkada.Canvas_View.Views;
-- with Gtkada.Handlers;                    use Gtkada.Handlers;
-- with Gtkada.Types;                       use Gtkada.Types;
-- with Pango.Font;                         use Pango.Font;
-- with System.Storage_Elements;            use System.Storage_Elements;

package body canvas_test is

	procedure dummy is begin null; end;

	View_Class_Record : aliased Glib.Object.Ada_GObject_Class := Glib.Object.Uninitialized_Class;


	H_Adj_Property    : constant Property_Id := 1;
	V_Adj_Property    : constant Property_Id := 2;

	function View_To_Model
		(Self   : not null access Canvas_View_Record;
		Rect   : View_Rectangle) return Model_Rectangle
	is
	begin
		return (X      => Rect.X / Self.Scale + Self.Topleft.X,
				Y      => Rect.Y / Self.Scale + Self.Topleft.Y,
				Width  => Rect.Width / Self.Scale,
				Height => Rect.Height / Self.Scale);
	end View_To_Model;

	function View_To_Model
		(Self   : not null access Canvas_View_Record;
		P      : View_Point) return Model_Point
	is
	begin
		return (X      => P.X / Self.Scale + Self.Topleft.X,
				Y      => P.Y / Self.Scale + Self.Topleft.Y);
	end View_To_Model;

	
	function Get_Visible_Area
		(Self : not null access Canvas_View_Record)
		return Model_Rectangle
	is
	begin
		return Self.View_To_Model
		((0.0,
			0.0,
			Gdouble (Self.Get_Allocated_Width),
			Gdouble (Self.Get_Allocated_Height)));
	end Get_Visible_Area;

	function Bounding_Box
		(Self   : not null access Canvas_Model_Record;
		Margin : Model_Coordinate := 0.0)
		return Model_Rectangle
	is
		Result : Model_Rectangle;
		Is_First : Boolean := True;

		procedure Do_Item (Item : not null access Abstract_Item_Record'Class);
		procedure Do_Item (Item : not null access Abstract_Item_Record'Class) is
			Box : constant Model_Rectangle := Item.Model_Bounding_Box;
		begin
			if Is_First then
			Is_First := False;
			Result := Box;
			else
			Union (Result, Box);
			end if;
		end Do_Item;
	begin
		Canvas_Model_Record'Class (Self.all).For_Each_Item
		(Do_Item'Access);

		if Is_First then
			return No_Rectangle;
		else
			Result.X := Result.X - Margin;
			Result.Y := Result.Y - Margin;
			Result.Width := Result.Width + 2.0 * Margin;
			Result.Height := Result.Height + 2.0 * Margin;
			return Result;
		end if;
	end Bounding_Box;
	
	procedure Set_Adjustment_Values
		(Self : not null access Canvas_View_Record'Class)
	is
		Box   : Model_Rectangle;
		Area  : constant Model_Rectangle := Self.Get_Visible_Area;
		Min, Max : Gdouble;
	begin
		if Self.Model = null or else Area.Width <= 1.0 then
			--  Not allocated yet
			return;
		end if;

		--  We want a small margin around the minimal box for the model, since it
		--  looks better.

		Box := Self.Model.Bounding_Box (View_Margin / Self.Scale);

		--  We set the adjustments to include the model area, but also at least
		--  the current visible area (if we don't, then part of the display will
		--  not be properly refreshed).

		if Self.Hadj /= null then
			Min := Gdouble'Min (Area.X, Box.X);
			Max := Gdouble'Max (Area.X + Area.Width, Box.X + Box.Width);
			Self.Hadj.Configure
			(Value          => Area.X,
			Lower          => Min,
			Upper          => Max,
			Step_Increment => 5.0,
			Page_Increment => 100.0,
			Page_Size      => Area.Width);
		end if;

		if Self.Vadj /= null then
			Min := Gdouble'Min (Area.Y, Box.Y);
			Max := Gdouble'Max (Area.Y + Area.Height, Box.Y + Box.Height);
			Self.Vadj.Configure
			(Value          => Area.Y,
			Lower          => Min,
			Upper          => Max,
			Step_Increment => 5.0,
			Page_Increment => 100.0,
			Page_Size      => Area.Height);
		end if;

		Self.Viewport_Changed;
	end Set_Adjustment_Values;

	
	procedure View_Set_Property
		(Object        : access Glib.Object.GObject_Record'Class;
		Prop_Id       : Property_Id;
		Value         : Glib.Values.GValue;
		Property_Spec : Param_Spec)
	is
		pragma Unreferenced (Property_Spec);
		Self : constant Canvas_View := Canvas_View (Object);
	begin
		case Prop_Id is
			when H_Adj_Property =>
			Self.Hadj := Gtk_Adjustment (Get_Object (Value));
			if Self.Hadj /= null then
				Set_Adjustment_Values (Self);
				Self.Hadj.On_Value_Changed (On_Adj_Value_Changed'Access, Self);
				Self.Queue_Draw;
			end if;

			when V_Adj_Property =>
			Self.Vadj := Gtk_Adjustment (Get_Object (Value));
			if Self.Vadj /= null then
				Set_Adjustment_Values (Self);
				Self.Vadj.On_Value_Changed (On_Adj_Value_Changed'Access, Self);
				Self.Queue_Draw;
			end if;

			when H_Scroll_Property =>
			null;

			when V_Scroll_Property =>
			null;

			when others =>
			null;
		end case;
	end View_Set_Property;

	procedure View_Get_Property
		(Object        : access Glib.Object.GObject_Record'Class;
		Prop_Id       : Property_Id;
		Value         : out Glib.Values.GValue;
		Property_Spec : Param_Spec)
	is
		pragma Unreferenced (Property_Spec);
		Self : constant Canvas_View := Canvas_View (Object);
	begin
		case Prop_Id is
			when H_Adj_Property =>
			Set_Object (Value, Self.Hadj);

			when V_Adj_Property =>
			Set_Object (Value, Self.Vadj);

			when H_Scroll_Property =>
			Set_Enum (Value, Gtk_Policy_Type'Pos (Policy_Automatic));

			when V_Scroll_Property =>
			Set_Enum (Value, Gtk_Policy_Type'Pos (Policy_Automatic));

			when others =>
			null;
		end case;
	end View_Get_Property;
	
	procedure View_Class_Init (Self : GObject_Class);
	pragma Convention (C, View_Class_Init);
	--  Initialize the class record, in particular adding interfaces, for
	--  the view class.

	procedure View_Class_Init (Self : GObject_Class) is 
		use Glib.Properties.Creation;
	begin
		Set_Properties_Handlers (Self, View_Set_Property'Access, View_Get_Property'Access);

-- 		Override_Property (Self, H_Adj_Property, "hadjustment");
-- 		Override_Property (Self, V_Adj_Property, "vadjustment");
-- 		Override_Property (Self, H_Scroll_Property, "hscroll-policy");
-- 		Override_Property (Self, V_Scroll_Property, "vscroll-policy");
-- 
-- 		Set_Default_Draw_Handler (Self, On_View_Draw'Access);
-- 		Set_Default_Size_Allocate_Handler (Self, On_Size_Allocate'Access);
-- 		Set_Default_Realize_Handler (Self, On_View_Realize'Access);
	end View_Class_Init;
	
	
	function View_Get_Type return Glib.GType is
		Info : access GInterface_Info;
	begin
		if Glib.Object.Initialize_Class_Record
		(Ancestor     => Gtk.Bin.Get_Type,
-- 			Signals      => View_Signals,
			Class_Record => View_Class_Record'Access,
			Type_Name    => "GtkadaCanvasView",
			Parameters   => (1 => (1 => GType_None),
							2 => (1 => GType_Pointer),
							3 => (1 => GType_Pointer),
							4 => (1 => GType_Pointer)),
			Returns      => (1 => GType_None,
							2 => GType_Boolean),
			Class_Init   => View_Class_Init'Access)
		then
			Info := new GInterface_Info'
			(Interface_Init     => null,
			Interface_Finalize => null,
			Interface_Data     => System.Null_Address);
			Glib.Object.Add_Interface
			(View_Class_Record,
			Iface => Gtk.Scrollable.Get_Type,
			Info  => Info);
		end if;

		return View_Class_Record.The_Type;
	end View_Get_Type;

	
	procedure Initialize (
		Self  : not null access Canvas_View_Record'Class;
		Model : access Canvas_Model_Record'Class := null) is
	begin
		G_New (Self, View_Get_Type);
	end Initialize;


	
	Model_Class_Record : Glib.Object.Ada_GObject_Class := Glib.Object.Uninitialized_Class;
	
	function Model_Get_Type return Glib.GType is
	begin
		Glib.Object.Initialize_Class_Record
		(Ancestor     => GType_Object,
-- 			Signals      => Model_Signals,
			Class_Record => Model_Class_Record,
			Type_Name    => "GtkadaCanvasModel",
			Parameters   => (1 => (1 => GType_Pointer), --  item_content_changed
							2 => (1 => GType_None),  --  layout_changed
							3 => (1 => GType_Pointer),
							4 => (1 => GType_Pointer)));  --  item_destroyed
		return Model_Class_Record.The_Type;
	end Model_Get_Type;
	
	procedure Initialize
		(Self : not null access Canvas_Model_Record'Class) is
	begin
		if not Self.Is_Created then
			G_New (Self, Model_Get_Type);
		end if;

		--  ??? When destroyed, should unreferenced Self.Layout
	end Initialize;


	
	procedure Gtk_New
		(Self  : out Canvas_View;
		Model : access Canvas_Model_Record'Class := null) is
	begin
		Self := new Canvas_View_Record;
-- 		Initialize (Self, Model);
	end Gtk_New;

	
end canvas_test;
