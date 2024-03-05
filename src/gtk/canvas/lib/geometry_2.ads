------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                              GEOMETRY 2                                  --
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

with ada.numerics;
with ada.numerics.generic_elementary_functions;

with ada.containers;			use ada.containers;
with ada.containers.doubly_linked_lists;

with geometry_1;				use geometry_1;


package geometry_2 is

	-- The directions into which the an object can be moved
	-- by means of the cursor keys (arrow keys):
	type type_direction is (DIR_RIGHT, DIR_LEFT, DIR_UP, DIR_DOWN);


	

-- INTERNAL FLOAT TYPE:

	-- This float type is used for internal computations only:
	type type_float is new float; -- CS refinement required

	
	package pac_float_numbers_functions is new 
		ada.numerics.generic_elementary_functions (type_float);


		
-- DISTANCE:
	
	-- The model coordinates system uses so called
	-- decimal fixed point numbers for distances and positions:
	type type_distance_model is delta 0.01 digits 8 
		range -100_000.00 .. 100_000.00;


	-- This function returns the given distance 
	-- as string:	
	function to_string (
		distance : in type_distance_model)
		return string;

	

-- ROTATION / ANGLE:
	
	-- The model coordinates system uses so called
	-- decimal fixed point numbers for angles and rotations:
	rotation_smallest : constant := 0.01;
	type type_rotation_model is delta rotation_smallest digits 5 
		range -360.0 + rotation_smallest .. 360.0 - rotation_smallest;

		
	-- Converts the given rotation/angle to a string:
	function to_string (
		rotation : in type_rotation_model)
		return string;


	
	
-- POINT / POSITION / LOCATION / LOCATION VECTOR / DISTANCE VECTOR:
	
	type type_vector_model is record
		x, y : type_distance_model := 0.0;
	end record;


	-- This function returns the given vector
	-- as string:
	function to_string (
		v : in type_vector_model)
		return string;


	-- This function inverts a vector by multiplying
	-- its components by -1:
	function invert (
		point	: in type_vector_model)
		return type_vector_model;
	
						 
	-- Moves a model point by the given offset:
	procedure move_by (
		point	: in out type_vector_model;
		offset	: in type_vector_model);



	
	-- Returns the absolute distance between the given
	-- model points. Uses internally a float type:
	function get_distance (
		p1, p2 : in type_vector_model)
		return type_distance_model;
	

	-- Returns the angle of direection from the given 
	-- point p1 to the point p2. Uses internally a float type:
	function get_angle (
		p1, p2 : in type_vector_model)
		return type_rotation_model;



-- ORIGIN:
	
	-- The origin is a small cross at model position (0;0).
	origin				: constant type_vector_model := (0.0, 0.0);
	origin_size			: constant gdouble := 10.0; -- the arm-length of the cross
	origin_linewidth	: constant gdouble := 1.0;




	
-- AREA:
	
	type type_area is record
		width		: type_distance_model := 0.0; -- CS should be positive
		height		: type_distance_model := 0.0; -- CS should be positive
		position	: type_vector_model; -- lower left corner
	end record;

	
	-- Returns the position and dimensions of the given area as string:
	function to_string (
		box : in type_area)
		return string;


	-- In order to handle the four corners of an
	-- area this type is required:
	type type_area_corners is record
		BL, BR, TL, TR : type_vector_model;
	end record;


	-- Returns the four corners of the given area.
	-- The area is given in model coordinates:
	function get_corners (
		area	: in type_area)
		return type_area_corners;

	
	-- Returns the center of the given area:
	function get_center (
		area	: in type_area)
		return type_vector_model;
	

	
	-- Returns true if the given point lies inside the given
	-- area or on its border. 
	function in_area (
		point	: in type_vector_model;
		area	: in type_area)
		return boolean;


	-- Returns true if the given areas overlap each other:
	function areas_overlap (
		A, B : in type_area)
		return boolean;


	-- Merges the given area B into area A:
	procedure merge_areas (
		A : in out type_area;
		B : in type_area);
	

	
end geometry_2;

