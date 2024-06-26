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

with demo_logical_pixels;		use demo_logical_pixels;
with demo_geometry;				use demo_geometry;


package demo_zoom is

	-- This is the specification of the zoom factor
	-- (German: Vergroesserungsfaktor)
	type type_zoom_factor is digits 3 range 0.10 .. 100.0;
	

	-- This is the global zoom factor:
	S : type_zoom_factor := 1.0;

	-- This is the multiplier that is used when the
	-- global zoom factor is increased or decreased:
	SM : constant type_zoom_factor := 1.2;

	

	-- Converts the given zoom factor to a string.
	-- CS: Since type_zoom_factor is a float type, the output is
	-- something like 1.44E+00. Instead the output should be something
	-- simpler like 1.44:
	function to_string (
		zf : in type_zoom_factor)
		return string;


	-- This procedure increases the global zoom factor
	-- by multiplying it by SM:
	procedure increase_zoom_factor;

	
	-- This procedure decreases the global zoom factor
	-- by dividing it by SM:
	procedure decrease_zoom_factor;

	

	-- There are two kinds of zoom-operations:
	type type_zoom_direction is (ZOOM_IN, ZOOM_OUT);

	
	-- This procedure sets the global translate-offset T that is
	-- required for a zoom-operation.
	-- After changing the zoom factor S (either by zoom on mouse pointer or
	-- by zoom on cursor), the translate-offset T must
	-- be calculated anew. The computation requires as input values
	-- the zoom center as virtual model point (CS1) or as canvas point (CS2).
	-- So there is a procedure set_translation_for_zoom that takes a canvas 
	-- point and another that takes a real model point.
	-- Later, when the actual drawing takes place (see function 
	-- cb_draw_objects) the drawing will be dragged back by the 
	-- translate-offset so that the operator gets the impression of a 
	-- zoom-in or zoom-out effect.
	-- Without applying a translate-offset the drawing would be appearing as 
	-- expanding to the upper-right (on zoom-in) or shrinking toward the 
	-- lower-left:
	procedure set_translation_for_zoom (
		-- The zoom factor before zoom:
		S1	: in type_zoom_factor;		

		-- The zoom factor after zoom:
		S2	: in type_zoom_factor;		

		-- The zoom center as canvas point:
		Z1	: in type_logical_pixels_vector); 


	
	procedure set_translation_for_zoom (
		-- The zoom factor before zoom:
		S1	: in type_zoom_factor;

		-- The zoom factor after zoom:
		S2	: in type_zoom_factor;

		-- The zoom center as a real model point:
		M	: in type_vector_model); 



	

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
		l1		: type_logical_pixels_vector; -- the start point
		l2		: type_logical_pixels_vector; -- the end point
	end record;



	-- This is the instance of the zoom-area:
	zoom_area : type_zoom_area;

	
	-- This is the linewidth of the rectangle that
	-- marks the selected zoom area:
	zoom_area_linewidth : constant type_logical_pixels_positive := 2.0;


	-- This procedure resets the zoom_area (see above)
	-- to its default values. 
	-- Use this procedure to abort a zoom-to-area operation.
	procedure reset_zoom_area;



	-- Zooms in or out at the current cursor position.
	-- If the direction is ZOOM_IN, then the global zoom factor S
	-- is increased by multplying it with the zoom multiplier SM.
	-- If direction is ZOOM_OUT then it decreases by dividing
	-- by SM:
	procedure zoom_on_cursor (
		direction : in type_zoom_direction);


	-- This procedure sets the global zoom factor S and translate-offset T
	-- so that all objects of the given area fit into the scrolled window.
	-- The zoom center is the top-left corner of the given area.
	procedure zoom_to_fit (
		area : in type_area);


	-- This procedure sets the global zoom factor S and translate-offset T
	-- so that all objects of bounding-box fit into the scrolled window.
	-- The zoom center is the top-left corner of bounding-box.
	procedure zoom_to_fit_all;


	-- If a zoom-to-area operation has started, then
	-- this procedure draws the rectangle around the
	-- area to be zoomed at.
	-- The rectangle is drawn directly on the cairo_context.
	procedure draw_zoom_area;
	
end demo_zoom;
