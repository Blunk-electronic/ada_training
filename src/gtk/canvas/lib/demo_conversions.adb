------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                              CONVERSIONS                                 --
--                                                                          --
--                               B o d y                                    --
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

with ada.text_io;				use ada.text_io;
with demo_bounding_box;			use demo_bounding_box;
with demo_base_offset;			use demo_base_offset;
with demo_translate_offset;		use demo_translate_offset;


package body demo_conversions is


	function to_real (
		point : in type_vector_model)
		return type_vector_model
	is	
		use demo_bounding_box;
		result : type_vector_model := point;
	begin
		move_by (result, bounding_box.position);
		return result;
	end to_real;


	function to_virtual (
		point : in type_vector_model)
		return type_vector_model
	is
		use demo_bounding_box;
		result : type_vector_model := point;
	begin
		move_by (result, invert (bounding_box.position));
		return result;
	end to_virtual;



	function to_distance (
		d : in type_distance_model_positive)
		return type_logical_pixels_positive
	is begin
		return type_logical_pixels (d) * type_logical_pixels (S);
	end to_distance;


	function to_distance (
		d : in type_logical_pixels_positive)
		return type_distance_model_positive
	is begin
		return type_distance_model_positive (d / type_logical_pixels (S));
	end to_distance;

	

	function to_virtual (
		point	: in type_logical_pixels_vector;
		zf		: in type_zoom_factor)
		return type_vector_model
	is 
		result : type_vector_model;
		debug : boolean := false;
	begin
		result.x := type_distance_model 
			(( (point.x - T.x) - F.x) / type_logical_pixels (zf));
		
		result.y := type_distance_model 
			((-(point.y - T.y) - F.y) / type_logical_pixels (zf));

		return result;
	end to_virtual;

	
	
	function to_model (
		point	: in type_logical_pixels_vector;
		zf		: in type_zoom_factor)
		return type_vector_model
	is 
		result : type_vector_model;
		debug : boolean := false;
	begin
		if debug then
			put_line ("to_model");
			put_line ("T " & to_string (T));
		end if;
		
		-- Compute the virtual model point corresponding
		-- to the given canvas point:
		result := to_virtual (point, zf);
		
		-- The result must be compensated by the bounding-box position
		-- in order to obtain a real model point:
		move_by (result, bounding_box.position);

		return result;

		exception
			when constraint_error =>
				put_line ("ERROR: conversion from canvas point "
					& "to model point failed !");
				put_line (" point " & to_string (point));
				put_line (" zf    " & to_string (zf));
				put_line (" T     " & to_string (T));
				put_line (" F     " & to_string (F));
				raise;						  
	end to_model;


	
	function virtual_to_canvas (
		point 	: in type_vector_model;
		zf		: in type_zoom_factor)
		return type_logical_pixels_vector
	is
		P : type_vector_model := point;
		result : type_logical_pixels_vector;
	begin
		result.x :=  (type_logical_pixels (P.x) * type_logical_pixels (zf)
					+ F.x);
		
		result.y := -(type_logical_pixels (P.y) * type_logical_pixels (zf)
					+ F.y);
		
		return result;
	end virtual_to_canvas;

	

	function to_canvas (
		point 	: in type_vector_model;
		zf		: in type_zoom_factor)
		return type_logical_pixels_vector
	is
		P : type_vector_model := point;
		result : type_logical_pixels_vector;
	begin
		-- The given real model point must must
		-- be compensated by the inverted bounding-box position
		-- in order to get a virtual model point:
		move_by (P, invert (bounding_box.position));


		result := virtual_to_canvas (P, zf);
		
		-- Move result by the current translate-offset:
		result.x := result.x + T.x;
		result.y := result.y + T.y;
		
		return result;
	end to_canvas;

	

	function get_bounding_box_corners
		return type_bounding_box_corners
	is
		result : type_bounding_box_corners;

		-- The corners of the given area in model-coordinates:
		BC : constant type_area_corners := get_corners (bounding_box);

	begin
		-- Convert the corners of the bounding-box to canvas coordinates:
		result.TL := to_canvas (BC.TL, S);
		result.TR := to_canvas (BC.TR, S);
		result.BL := to_canvas (BC.BL, S);
		result.BR := to_canvas (BC.BR, S);
		
		return result;
	end get_bounding_box_corners;
	
end demo_conversions;

