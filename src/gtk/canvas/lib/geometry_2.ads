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



	
-- GRID:
	
	-- The grid helps the operator to align or place objects:
	type type_grid_on_off is (GRID_ON, GRID_OFF);
	type type_grid_style is (STYLE_DOTS, STYLE_LINES);

	-- The linewidth of the grid lines:
	grid_width_lines : constant gdouble := 0.5;

	-- The linewidth of the circles which form the grid dots:
	grid_width_dots : constant gdouble := 1.0;
	grid_radius_dots : constant gdouble := 0.5;

	-- The default grid size in in the model domain:
	grid_spacing_default : constant type_distance_model := 10.0;

	-- If the displayed grid is too dense, then it makes no
	-- sense to draw a grid. For this reason we define a minimum
	-- distance between grid rows and columns. If the spacing becomes
	-- greater than this threshold then the grid will be drawn:
	grid_spacing_min : constant gdouble := 10.0;
	
	type type_grid is record
		on		: type_grid_on_off := GRID_ON;
		-- on		: type_grid_on_off := GRID_OFF;
		spacing : type_vector_model := (others => grid_spacing_default);
		style	: type_grid_style := STYLE_DOTS;
		-- style	: type_grid_style := STYLE_LINES;
	end record;
	
	grid : type_grid;

	
	-- This function returns the grid point that is
	-- closest to the given model point;
	function snap_to_grid (
		point : in type_vector_model)
		return type_vector_model;



	
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


	
	-- Converts a virtual model point to a real model point:
	function to_real (
		point : in type_vector_model)
		return type_vector_model;

	-- Converts a real model point to a virtual model point:
	function to_virtual (
		point : in type_vector_model)
		return type_vector_model;



	-- The margin around the drawing is part of the model.
	-- The bounding box includes the margin:
	margin : constant type_distance_model := 5.0;
	
	margin_offset : constant type_vector_model := (
		x	=> margin,
		y	=> margin);

	
	

	-- This is the bounding-box of the model. It is a rectangle
	-- that encloses all objects of the model and the margins 
	-- around the model:
	bounding_box : type_area;

	-- These are the system limits for the width and height
	-- of the bounding-box of the model:
	bounding_box_width_max  : constant type_distance_model := 2_000.0;
	bounding_box_height_max : constant type_distance_model := 1_000.0;

	
	
	-- The simplest object in the model world is a line:
	type type_line is record
		s, e : type_vector_model; -- start and end point
		w : type_distance_model; -- linewidth
	end record;

	
	-- Returns the bounding-box of the given line.
	-- It respects the linewidth and assumes that the line ends
	-- have round caps:
	function get_bounding_box (
		line : in type_line)
		return type_area;

	
	-- Moves a line by the given offset:
	procedure move_line (
		line	: in out type_line;
		offset	: in type_vector_model);

	
	
	-- Another primitive object is a circle:
	type type_circle is record
		c : type_vector_model;
		r : type_distance_model; -- the radius
		w : type_distance_model; -- the linewidth
		-- CS: fill status
	end record;

	
	-- Returns the bounding-box of the given circle.
	-- It respects the linewidth of the circumfence:
	function get_bounding_box (
		circle : in type_circle)
		return type_area;
	
	-- CS arc ?

	

	

	
	-- Returns true if the given areas overlap each other:
	function areas_overlap (
		A, B : in type_area)
		return boolean;


	-- Merges the given area B into area A:
	procedure merge_areas (
		A : in out type_area;
		B : in type_area);
	

	
	


	
	
	type type_object is abstract tagged record
		p : type_vector_model;
	end record;

	

	package pac_lines is new doubly_linked_lists (element_type => type_line);
	package pac_circles is new doubly_linked_lists (element_type => type_circle);
	
	type type_complex_object is new type_object with record
		lines	: pac_lines.list;
		circles	: pac_circles.list;
	end record;

	package pac_objects is new doubly_linked_lists (element_type => type_complex_object);
	objects_database : pac_objects.list;


	procedure make_database;


	-- This procedure pareses the whole database of model objects,
	-- detects the smallest and greatest x and y values used by the model
	-- and sets the global variable bounding_box accordingly.
	-- If the bounding_box has changed, then the flag bounding_box_changed is
	-- set (See below).
	--
	-- It modifies following global veriables:
	-- - bounding_box
	-- - bounding_box_changed
	-- - bounding_box_error
	--
	-- The arguments can be used to:
	-- - Abort on first error. Means NOT to parse the whole database but to
	--   abort the parsing on the first violation of the maximal allowed 
	--   dimensions (width and height).
	-- - Ignore errors. Means to generate a bounding-box that might be
	--   wider or taller than actually allowed. This is useful for debugging
	--   and testing the effects of violations of maximal bounding-box 
	--   dimensions.
	-- - Test only. Means to simulate the compuation of the bounding-box only.
	--   The global variable bounding_box will NOT be touched in any case.
	procedure compute_bounding_box (
		abort_on_first_error	: in boolean := false; -- CS currently not implemented
		ignore_errors			: in boolean := false;
		test_only				: in boolean := false);


	-- Indicates that the bounding_box has changed after calling procedure 
	-- compute_bounding_box:
	bounding_box_changed : boolean := false;

	type type_bounding_box_error is record
		size_exceeded	: boolean := false;
		width			: type_distance_model := 0.0;
		height			: type_distance_model := 0.0;
		-- CS ? position : type_vector_model;
	end record;

	bounding_box_error : type_bounding_box_error;


	
	procedure add_object;

	procedure delete_object;
	
end geometry_2;

