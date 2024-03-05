------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                                 ZOOM                                     --
--                                                                          --
--                                S p e c                                   --
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
with geometry_1;				use geometry_1;
with geometry_2;				use geometry_2;
with demo_scale_factor;			use demo_scale_factor;


package demo_zoom is

	-- There are two kinds of zoom-operations:
	type type_zoom_direction is (ZOOM_IN, ZOOM_OUT);



	-- This procedure sets the global translate-offset T that is
	-- required for a zoom-operation.
	-- After changing the scale-factor S (either by zoom on mouse pointer or
	-- by zoom on cursor), the translate-offset T must
	-- be calculated anew. The computation requires as input values
	-- the zoom center as virtual model point (CS1) or as canvas point (CS2).
	-- So there is a procedure set_translation_for_zoom that takes a canvas point
	-- and another that takes a real model point.
	-- Later, when the actual drawing takes place (see function cb_draw_objects)
	-- the drawing will be dragged back by the translate-offset
	-- so that the operator gets the impression of a zoom-into or zoom-out effect.
	-- Without applying a translate-offset the drawing would be appearing as 
	-- expanding to the upper-right (on zoom-in) or shrinking toward the lower-left:
	procedure set_translation_for_zoom (
		S1	: in type_scale_factor;		-- the scale factor before zoom
		S2	: in type_scale_factor;		-- the scale factor after zoom
		Z1	: in type_vector_gdouble);	-- the zoom center as canvas point

	procedure set_translation_for_zoom (
		S1	: in type_scale_factor;		-- the scale factor before zoom
		S2	: in type_scale_factor;		-- the scale factor after zoom
		M	: in type_vector_model);	-- the zoom center as a real model point



	

	-- This composite type provides the ingredients
	-- required to do a zoom-to-area operation:
	type type_zoom_area is record
		-- This flag indicates that the operation is active.
		-- As soon as the operator clicks the "Zoom Area" button,
		-- this flag is set. It is cleared when the operator
		-- releases the right mouse button after she/he has
		-- defined the zoom-area. The zoom-area is a
		-- rectangle:
		active	: boolean := false; 

		-- This is the first corner of the area. It is assigned
		-- when the operator presses the right mouse button
		-- on the canvas to define the start point of the zoom-area:
		k1		: type_vector_model;

		-- This is the second corner of the area. It is assigned
		-- when the operator releases the right mouse button
		-- on the canvas to define end point of the the zoom-area:
		k2		: type_vector_model;

		-- This is the actual area to be zoomed to. It gets fully
		-- specified when the operator releases the right mouse button.
		-- The area will then be passed to the function zoom_to_fit
		-- in order to have the area displayed on the canvas:
		area	: type_area;

		---------------------------------------------------------------
		-- In order to display a rectangle that indicates the
		-- currently selected area we need this stuff.
		-- This is all in the canvas domain and has nothing to
		-- do with the area in the model domain (see above):
		
		-- This flag indicates that the operator has started
		-- the selection. It is cleared when the operator is done
		-- with the selection by releasing the right mouse button:
		started	: boolean := false;

		-- The corners of the selected area:
		l1		: type_vector_gdouble; -- the start point
		l2		: type_vector_gdouble; -- the end point
	end record;



	-- This is the instance of the zoom-area:
	zoom_area : type_zoom_area;

	
	-- This is the linewidth of the rectangle that
	-- marks the selected zoom area:
	zoom_area_linewidth : constant gdouble := 2.0;


	-- This procedure resets the zoom_area (see above)
	-- to its default values. 
	-- Use this procedure to abort a zoom-to-area operation.
	procedure reset_zoom_area;



	-- Zooms in or out at the current cursor position.
	-- If the direction is ZOOM_IN, then the global scale-factor S
	-- is increased by multplying it with the scale_multiplier.
	-- If direction is ZOOM_OUT then it decreases by dividing
	-- by scale_multiplier:
	procedure zoom_on_cursor (
		direction : in type_zoom_direction);


	-- This procedure sets the global scale-factor S and translate-offset T
	-- so that all objects of the given area fit into the scrolled window.
	-- The zoom center is the top-left corner of the given area.
	procedure zoom_to_fit (
		area : in type_area);


	-- This procedure sets the global scale-factor S and translate-offset T
	-- so that all objects of bounding-box fit into the scrolled window.
	-- The zoom center is the top-left corner of bounding-box.
	procedure zoom_to_fit_all;
	
end demo_zoom;

