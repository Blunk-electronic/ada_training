------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                    CALLBACK FUNCTIONS AND PROCEDURES                     --
--                                                                          --
--                               S p e c                                    --
--                                                                          --
-- Copyright (C) 2024                                                       --
-- Mario Blunk / Blunk electronic                                           --
-- Buchfinkenweg 3 / 99097 Erfurt / Germany                                 --
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

with glib;						use glib;
with gdk.event;					use gdk.event;
with gtk.window;				use gtk.window;
with gtk.widget;				use gtk.widget;
with gtk.button;				use gtk.button;
with gtk.adjustment;			use gtk.adjustment;
with cairo;						use cairo;

with demo_buttons;
with demo_logical_pixels;		use demo_logical_pixels;
with demo_geometry;				use demo_geometry;
with demo_window_dimensions;	use demo_window_dimensions;
with demo_canvas;				use demo_canvas;
with demo_main_window;			use demo_main_window;
with demo_zoom;					use demo_zoom;


package demo_callbacks is

	
	-- This callback procedure is called each time the 
	-- button "zoom fit" is clicked.
	procedure cb_zoom_to_fit (
		button : access gtk_button_record'class);

	
	-- This callback procedure is called each time the 
	-- button "zoom area" is clicked.
	procedure cb_zoom_area (
		button : access gtk_button_record'class);

	
	-- This callback procedure is called each time the 
	-- button "add" is clicked.
	procedure cb_add (
		button : access gtk_button_record'class);

	
	-- This callback procedure is called each time the 
	-- button "delete is clicked.
	procedure cb_delete (
		button : access gtk_button_record'class);

	
	-- This callback procedure is called each time the 
	-- button "move" is clicked.
	procedure cb_move (
		button : access gtk_button_record'class);

	
	-- This callback procedure is called each time the 
	-- button "export" is clicked:
	procedure cb_export (
		button : access gtk_button_record'class);
	



-- MAIN WINDOW:

	-- This procedure is called when the operator terminates
	-- the demo program by clicking the X in the upper right corner
	-- of the main window:
	procedure cb_terminate (
		window : access gtk_widget_record'class);


	procedure cb_window_focus (
		window : access gtk_window_record'class);


	-- This function is called each time the operator
	-- presses a mouse button.
	function cb_window_button_pressed (
		window	: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;


	-- This function is called each time the operator
	-- hits a key on the keyboard. It does not matter
	-- which widget inside the main window has the focus.
	-- This callback function is at the top of the event-chain.
	-- It is called at first on a key-press event.
	-- If it returns false, then it signals to the 
	-- next widget in the chain downwards to handle the event
	-- further.
	-- The return should depend on the severity of the key.
	-- For example in case of an "emergency-exit" 
	-- the operator hits the ESC key, which causes the abort of
	-- all pending operations. In this case the return would be true
	-- and the event would not be passed on to any widgets down
	-- the chain.
	function cb_window_key_pressed (
		window	: access gtk_widget_record'class;
		event	: gdk_event_key)
		return boolean;
	

	
	-- This callback procedure is called each time the 
	-- size_allocate signal is emitted by the main window:
	procedure cb_main_window_size_allocate (
		window		: access gtk_widget_record'class;
		allocation	: gtk_allocation);


	-- This procedure instantiates the main window,
	-- sets the title bar, connects signals with callback
	-- subprograms and creates boxes inside the window:
	procedure set_up_main_window;


	

	
-- SCROLLED WINDOW AND SCROLLBARS:
		
	
	-- This callback procedure is called each time the size_allocate signal
	-- is emitted by the scrolled window.
	procedure cb_swin_size_allocate (
		swin		: access gtk_widget_record'class;
		allocation	: gtk_allocation);
	

	-- This procedure creates the scrolled window,
	-- assigns to it the initial size (widht and height)
	-- and sets the behaviour of them.
	-- It also connects the signals emitted by the scrollbars
	-- with the callback subprograms.
	procedure set_up_swin_and_scrollbars;

	
	
	-- This procedure is called whenever the horizontal scrollbar is moved, 
	-- either by the operator or by internal calls.
	procedure cb_horizontal_moved (
		scrollbar : access gtk_adjustment_record'class);

	
	-- This procedure is called whenever the vertical scrollbar is moved, 
	-- either by the operator or by internal calls.
	procedure cb_vertical_moved (
		scrollbar : access gtk_adjustment_record'class);


	-- This procedure is called when the operator clicks
	-- on the vertical scrollbar:
	function cb_scrollbar_v_pressed (
		bar		: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;
	

	-- This procedure is called when the operator releases
	-- the mouse button after clicking on the vertical scrollbar:
	function cb_scrollbar_v_released (
		bar		: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;


	-- This procedure is called when the operator clicks
	-- on the horizontal scrollbar:
	function cb_scrollbar_h_pressed (
		bar		: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;
	
	
	-- This procedure is called when the operator releases
	-- the mouse button after clicking on the horizontal scrollbar:
	function cb_scrollbar_h_released (
		bar		: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;


	
-- CANVAS:

	-- This procedure is called when the canvas changes
	-- its size. It is not used currently because the canvas
	-- has a fixed size in this demo program (see below):
	procedure cb_canvas_size_allocate (
		canvas		: access gtk_widget_record'class;
		allocation	: gtk_allocation);

	
	-- This procedure creates the canvas, assigns to
	-- it a fixed size and connects its signals
	-- with callback subprograms:
	procedure set_up_canvas;

	
	-- This callback function is called each time the operator
	-- clicks on the canvas.
	-- It sets the focus on the canvas and moves the cursor
	-- to the place where the operator has clicked the canvas.
	function cb_canvas_button_pressed (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;


	-- This callback function is called each time the operator
	-- releases a mouse button after clicking on the canvas.
	function cb_canvas_button_released (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_button)
		return boolean;

	
	-- This callback function is called each time the operator
	-- moves the pointer (or the mouse) inside the canvas:
	function cb_canvas_mouse_moved (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_motion)
		return boolean;


	-- This callback function is called each time the
	-- operator hits a key and if the canvas has the focus:
	function cb_canvas_key_pressed (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_key)
		return boolean;


	-- This function is called each time the mouse wheel is
	-- rolled inside the canvas by the operator:
	function cb_mouse_wheel_rolled (
		canvas	: access gtk_widget_record'class;
		event	: gdk_event_scroll)
		return boolean;
	
	
	-- This function is called each time the canvas 
	-- is to be refreshed when it gets the
	-- "on_draw"-signal. See also the body of procedure "set_up_canvas"
	-- where the signal connection is made.
	--
	-- NOTE: This function is also called by other signals, such as
	-- "grab_focus". The corresponding connection is active by default.
	--
	-- It draws everything: frame, grid, cursor, objects
	function cb_draw (
		canvas		: access gtk_widget_record'class;
		context_in	: in cairo_context)
		return boolean;


end demo_callbacks;

