------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                              CONVERSIONS                                 --
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

with demo_logical_pixels;		use demo_logical_pixels;
with demo_geometry;				use demo_geometry;
with demo_zoom;					use demo_zoom;

package demo_conversions is

-- REAL <-> VIRTUAL MODEL COORDINATES:
	
	-- Converts a virtual model point to a real model point:
	function to_real (
		point : in type_vector_model)
		return type_vector_model;

	
	-- Converts a real model point to a virtual model point:
	function to_virtual (
		point : in type_vector_model)
		return type_vector_model;


	

-- CANVAS <-> MODEL:


	-- Converts the given model distance to
	-- a canvas distance according to the current scale-factor S:
	function to_distance (
		d : in type_distance_model_positive)
		return type_logical_pixels_positive;

	
	-- Converts the given canvas distance to
	-- a model distance according to the current scale-factor S:
	function to_distance (
		d : in type_logical_pixels_positive)
		return type_distance_model_positive;


	
	-- Converts a canvas point to a model point
	-- according to the given scale factor, the current
	-- base-offset and the current tranlate-offset.
	-- If a real model point is required, then the position
	-- of the current bonding-box is also taken into account:
	function to_model (
		point	: in type_logical_pixels_vector;
		scale	: in type_scale_factor;
		real 	: in boolean := false) 
		return type_vector_model;
	

	-- Converts a model point to a canvas point
	-- according to the given scale factor and the current
	-- base-offset.
	-- If the given model point is real, then the current
	-- tranlate-offset and the position of the current
	-- bounding-box is also taken into account:
	function to_canvas (
		point 	: in type_vector_model;
		scale	: in type_scale_factor;
		real	: in boolean := false)
		return type_logical_pixels_vector;



	-- In connection with zoom-operations we need the corners of the
	-- bounding-box in canvas coordinates. This composite type serves this
	-- purpose:
	type type_bounding_box_corners is record
		BL, BR, TL, TR : type_logical_pixels_vector;
	end record;

	
	-- This function returns the current corners of the bounding-box
	-- in canvas-coordinates. The return depends on the current scale-factor S
	-- and translate-offset:
	function get_bounding_box_corners
		return type_bounding_box_corners;
		
	
end demo_conversions;
