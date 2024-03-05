------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                                CANVAS                                    --
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

with gtk.widget;				use gtk.widget;
with gtk.drawing_area;			use gtk.drawing_area;
with demo_logical_pixels;		use demo_logical_pixels;
with geometry_2;				use geometry_2;
with demo_window_dimensions;	use demo_window_dimensions;



package demo_canvas is

	-- This is the canvas where all the drawing takes place:
	canvas : gtk_drawing_area;


	-- This is the size of the canvas in device pixels.
	-- It is set by procedure compute_canvas_size on system startup:
	canvas_size : type_window_size;


	-- This procedure should be called in order to schedule
	-- a refresh (or redraw) of the canvas:
	procedure refresh (
		canvas	: access gtk_widget_record'class);
	

	-- This procedure computes the dimensions of the canvas
	-- and assigns them to variable canvas_size.
	-- The computation bases on the maximum allowed width
	-- and height of the bounding-box and the maximal
	-- scale-factor.
	-- CS: The computed dimensions may be not sufficient
	-- with very very large screens:
	procedure compute_canvas_size;

	
	-- This procedure outputs the current dimensions
	-- of the canvas on the console:
	procedure show_canvas_size;

	-- This procedure creates the canvas, sets its size,
	-- and adds it into the scrolled window.
	-- It also adds events to be sensitive to:
	procedure create_canvas;


	-- Shifts the canvas into the given direction
	-- by the given distance:
	procedure shift_canvas (
		direction	: type_direction;
		distance	: type_distance_model);

end demo_canvas;

