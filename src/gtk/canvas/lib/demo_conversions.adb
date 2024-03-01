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
		d : in type_distance_model)
		return type_distance_gdouble
	is begin
		return gdouble (d) * gdouble (S);
	end to_distance;


	function to_distance (
		d : in type_distance_gdouble)
		return type_distance_model
	is begin
		return type_distance_model (d / gdouble (S));
	end to_distance;

	

	
	function to_model (
		point	: in type_vector_gdouble;
		scale	: in type_scale_factor;
		real 	: in boolean := false)
		return type_vector_model
	is 
		result : type_vector_model;
		debug : boolean := false;
	begin
		if debug then
			put_line ("to_model");
			put_line ("T " & to_string (T));
		end if;
		
		result.x := type_distance_model (( (point.x - T.x) - F.x) / gdouble (scale));
		result.y := type_distance_model ((-(point.y - T.y) - F.y) / gdouble (scale));

		-- If real model coordinates are required, then the result must be compensated
		-- by the bounding-box position:
		if real then
			move_by (result, bounding_box.position);
		end if;
		return result;

		exception
			when constraint_error =>
				put_line ("ERROR: conversion from canvas point to model point failed !");
				put_line (" point " & to_string (point));
				put_line (" scale " & to_string (scale));
				put_line (" T     " & to_string (T));
				put_line (" F     " & to_string (F));
				put_line (" real  " & boolean'image (real));
				raise;						  
	end to_model;
	

	function to_canvas (
		point 	: in type_vector_model;
		scale	: in type_scale_factor;
		real	: in boolean := false)
		return type_vector_gdouble
	is
		P : type_vector_model := point;
		result : type_vector_gdouble;
	begin
		-- If real model coordinates are given, then they must
		-- be compensated by the inverted bounding-box position
		-- in order to get virtual model coordinates:
		if real then
			move_by (P, invert (bounding_box.position));
		end if;
		
		result.x :=  (gdouble (P.x) * gdouble (scale) + F.x);
		result.y := -(gdouble (P.y) * gdouble (scale) + F.y);

		if real then
			result.x := result.x + T.x;
			result.y := result.y + T.y;
		end if;
		
		return result;
	end to_canvas;

	
	
end demo_conversions;

