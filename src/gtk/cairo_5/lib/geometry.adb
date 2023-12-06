------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                               GEOMETRY                                   --
--                                                                          --
--                               B o d y                                    --
--                                                                          --
-- Copyright (C) 2023                                                       --
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
with glib;						use glib;

package body geometry is

	function to_string (
		scale : in type_scale_factor)
		return string
	is begin
		return type_scale_factor'image (scale);
	end to_string;
	
	
	procedure increase_scale is begin
		scale_factor := scale_factor * scale_multiplier;
		-- SM := SM * scale_multiplier;
		
		exception 
			when constraint_error =>
				put_line ("upper scale limit reached");
			when others => null;
	end increase_scale;

	
	procedure decrease_scale is begin
		scale_factor := scale_factor / scale_multiplier;
		
		exception 
			when constraint_error => 
				put_line ("lower scale limit reached");
			when others => null;
	end decrease_scale;


	function to_real (
		point : in type_point_model)
		return type_point_model
	is	
		result : type_point_model := point;
	begin
		move_by (result, bounding_box.position);
		return result;
	end to_real;


	function to_virtual (
		point : in type_point_model)
		return type_point_model
	is
		result : type_point_model := point;
	begin
		move_by (result, invert (bounding_box.position));
		return result;
	end to_virtual;

	

	function to_string (
		rotation : in type_rotation_model)
		return string
	is begin
		return type_rotation_model'image (rotation);
	end to_string;


	
	function get_grid_spacing (
		grid : in type_grid)
		return gdouble
	is
		s : constant gdouble := gdouble (scale_factor);
		x, y : gdouble;
	begin
		x := gdouble (grid.spacing.x) * s;
		y := gdouble (grid.spacing.y) * s;
		return gdouble'min (x, y);
	end get_grid_spacing;


	function snap_to_grid (
		point : in type_point_model)
		return type_point_model
	is
		n : integer;
		type type_float is new float; -- CS refinement required
		f : type_float;
		result : type_point_model;
	begin
		n := integer (point.x / grid.spacing.x);
		f := type_float (n) * type_float (grid.spacing.x);
		result.x := type_distance_model (f);

		n := integer (point.y / grid.spacing.y);
		f := type_float (n) * type_float (grid.spacing.y);
		result.y := type_distance_model (f);
		
		return result;
	end snap_to_grid;

	

	function to_string (
		distance : in type_distance_model)
		return string
	is begin
		return type_distance_model'image (distance);
	end to_string;

	
	function to_string (
		point	: in type_point_model)
		return string
	is begin
		return "model x/y: " & to_string (point.x) & "/" & to_string (point.y);
	end to_string;


	function invert (
		point	: in type_point_model)
		return type_point_model
	is begin
		return (- point.x, - point.y);
	end invert;

	

	procedure move_by (
		point	: in out type_point_model;
		offset	: in type_point_model)
	is begin
		point.x := point.x + offset.x;
		point.y := point.y + offset.y;
	end move_by;

	

	function to_string (
		point	: in type_point_canvas)
		return string
	is begin
		return "canvas x/y: " & gdouble'image (point.x) & "/" & gdouble'image (point.y);
	end to_string;



	function to_string (
		box : in type_area)
		return string
	is begin
		return "area (x/y/w/h): "
			& to_string (box.position) & "/"
			& to_string (box.width) & "/"
			& to_string (box.height);
	end to_string;


	function get_corners (
		area	: in type_area)
		return type_area_corners
	is
		result : type_area_corners;
	begin
		result.BL := (area.position.x, area.position.y);
		result.BR := (area.position.x + area.width, area.position.y);

		result.TL := (area.position.x, area.position.y + area.height); 
		result.TR := (area.position.x + area.width, area.position.y + area.height); 
		return result;
	end get_corners;

	
	function get_center (
		area	: in type_area)
		return type_point_model
	is
		result : type_point_model;
	begin
		result.x := area.position.x + area.width  * 0.5;
		result.y := area.position.y + area.height * 0.5;
		return result;
	end get_center;
		


	
	function in_area (
		point	: type_point_model;
		area	: type_area)
		return boolean
	is
		result : boolean := false;
	begin
		-- text x-axis:
		if point.x >= area.position.x then
			if point.x <= area.position.x + area.width then

				-- test y-axis:
				if point.y >= area.position.y then
					if point.y <= area.position.y + area.height then
						result := true;
					end if;
				end if;
				
			end if;
		end if;
		
		return result;
	end in_area;


	function in_height (
		point	: type_point_model;
		area	: type_area)
		return boolean
	is
		result : boolean := false;
	begin
		if point.y >= area.position.y then
			if point.y <= area.position.y + area.height then
				result := true;
			end if;
		end if;

		return result;
	end in_height;


	function in_width (
		point	: type_point_model;
		area	: type_area)
		return boolean
	is
		result : boolean := false;
	begin
		if point.x >= area.position.x then
			if point.x <= area.position.x + area.width then
				result := true;
			end if;
		end if;

		return result;
	end in_width;

	
	

	
	procedure compute_bounding_box is
	begin
		-- NOTE: In a real project, the database that contains
		-- all objects must be parsed here. But since this is a demo,
		-- we have just a single object (a rectangle) do deal with.
		
		-- Add to the object dimensions the margin. 
		-- The margin is part of the model and thus part 
		-- of the bounding box:
		bounding_box.width  := object.width  + 2.0 * margin;
		bounding_box.height := object.height + 2.0 * margin;
		
		-- Compute the position of the bounding-box.
		-- First we aquire the smallest x and y value used by the objects:
		bounding_box.position := object.lower_left_corner;

		-- Since we regard the margin as inside the bounding-box,
		-- we must move the bounding-box position towards bottom-left
		-- by the inverted margin_offset:
		move_by (bounding_box.position, invert (margin_offset));

		put_line ("bounding-box: " & to_string (bounding_box));
	end compute_bounding_box;

	
	function get_distance (
		p1, p2 : in type_point_model)
		return type_distance_model
	is
		use pac_float_numbers_functions;

		dx : type_float := abs (type_float (p2.x - p1.x));
		dy : type_float := abs (type_float (p2.y - p1.y));
		d : type_float;
	begin
		d := sqrt (dx**2.0 + dy**2.0);
		return type_distance_model (d);
	end get_distance;
	

	function get_angle (
		p1, p2 : in type_point_model)
		return type_rotation_model
	is
		use pac_float_numbers_functions;

		dx : type_float := type_float (p2.x - p1.x);
		dy : type_float := type_float (p2.y - p1.y);
		a : type_float;
	begin
		a := arctan (dy, dx, 360.0);
		return type_rotation_model (a);
	end get_angle;



	
	procedure clip_max (
		value	: in out gdouble;
		limit	: in gdouble)
	is begin
		if value > limit then
			value := limit;
		end if;
	end clip_max;
	
	
	procedure clip_min (
		value	: in out gdouble;
		limit	: in gdouble)
	is begin
		if value < limit then
			value := limit;
		end if;
	end clip_min;



	procedure compute_base_offset is
		x, y : gdouble;

		-- The maximum scale factor:
		S : constant gdouble := gdouble (type_scale_factor'last);
		By : constant gdouble := gdouble (bounding_box.height);
		Bx : constant gdouble := gdouble (bounding_box.width);
	begin
		x :=   Bx * S - Bx;
		y := - By * S;
		
		base_offset := (x, y);

		put_line ("base offset: " & to_string (base_offset));
	end compute_base_offset;


	procedure compute_translate_offset (
		MP	: in type_point_model;
		Z1	: in type_point_canvas)
	is 
		Z2 : type_point_canvas;
	begin			
		-- Compute the prospected canvas-point according to the 
		-- current scale_factor:
		Z2 := to_canvas (MP, scale_factor);
		-- put_line ("Z after scale   " & to_string (Z2));

		-- This is the offset from the given canvas-point Z1 to the prospected
		-- canvas-point Z2. The offset must be multiplied by -1 because the
		-- drawing must be dragged-back to the given pointer position:
		T.x := -(Z2.x - Z1.x);
		T.y := -(Z2.y - Z1.y);
		
		put_line (" T offset    " & to_string (T));
	end compute_translate_offset;


	
	
	function to_model (
		point	: in type_point_canvas;
		scale	: in type_scale_factor;
		real 	: in boolean := false)
		return type_point_model
	is 
		result : type_point_model;
		debug : boolean := false;
	begin
		if debug then
			put_line ("to_model");
			put_line ("T " & to_string (T));
		end if;
		
		result.x := type_distance_model (( (point.x - T.x) - base_offset.x) / gdouble (scale));
		result.y := type_distance_model ((-(point.y - T.y) - base_offset.y) / gdouble (scale));

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
				put_line (" F     " & to_string (base_offset));
				put_line (" real  " & boolean'image (real));
				raise;						  
	end to_model;
	

	function to_canvas (
		point 	: in type_point_model;
		scale	: in type_scale_factor;
		real	: in boolean := false)
		return type_point_canvas
	is
		P : type_point_model := point;
		result : type_point_canvas;
	begin
		-- If real model coordinates are given, then they must
		-- be compensated by the inverted bounding-box position
		-- in order to get virtual model coordinates:
		if real then
			move_by (P, invert (bounding_box.position));
		end if;
		
		result.x :=  (gdouble (P.x) * gdouble (scale) + base_offset.x);
		result.y := -(gdouble (P.y) * gdouble (scale) + base_offset.y);

		if real then
			result.x := result.x + T.x;
			result.y := result.y + T.y;
		end if;
		
		return result;
	end to_canvas;

	

	procedure make_object is
	begin
		object.lower_left_corner := (-10.0, -5.0);
		-- object.width  := 400.0;
		-- object.height := 200.0;
		
		-- object.lower_left_corner := (5.0, 5.0);
		object.width  := 390.0;
		object.height := 190.0;
	end make_object;
	
end geometry;

