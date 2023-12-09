------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                               GEOMETRY 1                                 --
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

package body geometry_1 is

	function to_string (
		scale : in type_scale_factor)
		return string
	is begin
		return type_scale_factor'image (scale);
	end to_string;
	
	
	procedure increase_scale is begin
		scale_factor := scale_factor * scale_multiplier;
		
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



	function to_distance (
		d : in type_distance_model)
		return type_distance_canvas
	is begin
		return gdouble (d) * gdouble (scale_factor);
	end to_distance;


	function to_distance (
		d : in type_distance_canvas)
		return type_distance_model
	is begin
		return type_distance_model (d / gdouble (scale_factor));
	end to_distance;

	
	
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

	
end geometry_1;

