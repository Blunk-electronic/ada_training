------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                              GEOMETRY 1                                  --
--                                                                          --
--                               S p e c                                    --
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

with glib;						use glib;

with ada.numerics;
with ada.numerics.generic_elementary_functions;

package geometry_1 is



-- SCALE:

	type type_scale_factor is digits 3 range 0.10 .. 10.0;
	scale_factor : type_scale_factor := 1.0;
	scale_multiplier : constant type_scale_factor := 1.2;


	-- Converts the given scale factor to a string.
	-- CS: Since type_scale_factor is a float type, the output is
	-- something like 1.44E+00. Instead the output should be something
	-- simpler like 1.44:
	function to_string (
		scale : in type_scale_factor)
		return string;
	
	procedure increase_scale;
	procedure decrease_scale;

	

-- MODEL:

	-- The model coordinates system uses so called
	-- decimal fixed point numbers for distances and positions:
	type type_distance_model is delta 0.01 digits 8 
		range -100_000.00 .. 100_000.00;
	
	type type_point_model is record
		x, y : type_distance_model := 0.0;
	end record;


	-- Converts a virtual model point to a real model point:
	function to_real (
		point : in type_point_model)
		return type_point_model;

	-- Converts a real model point to a virtual model point:
	function to_virtual (
		point : in type_point_model)
		return type_point_model;

	
	
	-- The model coordinates system uses so called
	-- decimal fixed point numbers for angles and rotations:
	rotation_smallest : constant := 0.01;
	type type_rotation_model is delta rotation_smallest digits 5 
		range -360.0 + rotation_smallest .. 360.0 - rotation_smallest;

		
	-- Converts the given rotation/angle to a string:
	function to_string (
		rotation : in type_rotation_model)
		return string;

	
	-- ORIGIN:
	-- The origin is a small cross at model position (0;0).
	origin				: constant type_point_model := (0.0, 0.0);
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
		spacing : type_point_model := (others => grid_spacing_default);
		style	: type_grid_style := STYLE_DOTS;
		-- style	: type_grid_style := STYLE_LINES;
	end record;
	
	grid : type_grid;

	-- This function returns the space between
	-- the grid columns or rows. It returns the lesser
	-- spacing of them. It calculates the spacing by this
	-- equation:
	-- x = grid.spacing.x * scale_factor
	-- y = grid.spacing.y * scale_factor
	-- Then the lesser one, either x or y will be returned:
	function get_grid_spacing (
		grid : in type_grid)
		return gdouble;


	-- This function returns the grid point that is
	-- closest to the given model point;
	function snap_to_grid (
		point : in type_point_model)
		return type_point_model;
	
	
	function to_string (
		distance : in type_distance_model)
		return string;

	
	function to_string (
		point	: in type_point_model)
		return string;


	
	function invert (
		point	: in type_point_model)
		return type_point_model;
	
						 
	-- Moves a model point by the given offset:
	procedure move_by (
		point	: in out type_point_model;
		offset	: in type_point_model);


	type type_area is record
		width		: type_distance_model; -- CS should be positive
		height		: type_distance_model; -- CS should be positive
		position	: type_point_model; -- lower left corner
	end record;


	type type_area_corners is record
		BL, BR, TL, TR : type_point_model;
	end record;


	-- Returns the four corners of the given area.
	-- The area is given in model coordinates:
	function get_corners (
		area	: in type_area)
		return type_area_corners;

	
	-- Returns the center of the given area:
	function get_center (
		area	: in type_area)
		return type_point_model;

	
	function to_string (
		box : in type_area)
		return string;

	
	-- Returns true if the given point lies inside the given
	-- area or on its border. 
	function in_area (
		point	: in type_point_model;
		area	: in type_area)
		return boolean;

	-- type type_relative_location is (
	-- 	LOC_RIGHT_OF,
	-- 	LOC_LEFT_OF,
	-- 	LOC_ABOVE,
	-- 	LOC_BELOW);
 -- 
	-- -- Returns the relative location
	-- function get_relative_location (
	-- 	point	: in type_point_model;
	-- 	area	: in type_area)
	-- 	return type_relative_location;
		
		
	-- Returns true if the given point lies inside the height 
	-- of the given area or on its lower or upper border. 
	function in_height (
		point	: type_point_model;
		area	: type_area)
		return boolean;

	-- Returns true if the given point lies inside the width 
	-- of the given area or on its left or right border. 
	function in_width (
		point	: type_point_model;
		area	: type_area)
		return boolean;

	

	
		
	-- This is the bounding-box of the model. It is a rectangle
	-- that encloses all objects of the model and the margins 
	-- around the model:
	bounding_box : type_area;

	
	
	
	-- The margin around the drawing is part of the model.
	-- The bounding box includes the margin:
	margin : constant type_distance_model := 5.0;
	
	margin_offset : constant type_point_model := (
		x	=> margin,
		y	=> margin);

	
	-- Detects the smallest and greatest x and y values used by the model.
	-- Sets the global variable bounding_box:
	procedure compute_bounding_box;


	
-- INTERNAL FLOAT TYPE:

	-- This float type is used for internal computations only:
	type type_float is new float; -- CS refinement required


	
	package pac_float_numbers_functions is new 
		ada.numerics.generic_elementary_functions (type_float);
	
	
	-- Returns the absolute distance between the given
	-- model points. Uses internally a float type:
	function get_distance (
		p1, p2 : in type_point_model)
		return type_distance_model;

	

	-- Returns the angle of direection from the given 
	-- point p1 to the point p2. Uses internally a float type:
	function get_angle (
		p1, p2 : in type_point_model)
		return type_rotation_model;



	
-- CANVAS:

	subtype type_distance_canvas is gdouble range 0.0 .. gdouble'last;
	
	type type_point_canvas is record
		x, y : gdouble := 0.0;
	end record;

		
	function to_string (
		point	: in type_point_canvas)
		return string;


	-- Converts the given model distance to
	-- a canvas distance according to the current scale_factor:
	function to_distance (
		d : in type_distance_model)
		return type_distance_canvas;

	
	-- Converts the given canvas distance to
	-- a model distance according to the current scale_factor:
	function to_distance (
		d : in type_distance_canvas)
		return type_distance_model;

	
	-- Clips the given value by the given limit.
	-- If the given value is less or equal the limit,
	-- then value remains unchanged:
	procedure clip_max (
		value	: in out gdouble;
		limit	: in gdouble);
	
	-- Clips the given value by the given limit.
	-- If the given value is greater or equal the limit,
	-- then value remains unchanged:
	procedure clip_min (
		value	: in out gdouble;
		limit	: in gdouble);
	

	
	-- The place on the canvase where the model 
	-- coordinates system has its origin:
	base_offset : type_point_canvas;
		

	procedure compute_base_offset;

	-- The global translate-offset by which all draw operations on the canvas
	-- are translated when the operator zooms on the pointer or the cursor:
	T : type_point_canvas := (0.0, 0.0);


	-- This procedure updates the global translate-offset T.
	-- After changing the scale_factor (either by zoom on mouse pointer or
	-- by zoom on cursor), the translate_offset T must
	-- be calculated anew. The computation requires as input values
	-- the zoom center as virtual model point and as the corresponding
	-- canvas point.
	-- Later, when the actual drawing takes place (see function cb_draw_objects)
	-- the drawing will be dragged back by the translate_offset
	-- so that the operator gets the impression of a zoom-into or zoom-out effect.
	-- Without applying a translate_offset the drawing would be appearing as 
	-- expanding to the upper-right (on zoom-in) or shrinking toward the lower-left:
	procedure compute_translate_offset (
		MP	: in type_point_model;		-- the virtual zoom center as model point
		Z1	: in type_point_canvas);	-- the zoom center as canvas point
	

-- CONVERSION BETWEEN MODEL AND CANVAS:

	function to_model (
		point	: in type_point_canvas;
		scale	: in type_scale_factor;
		real 	: in boolean := false) -- if real model coordinates are required
		return type_point_model;
	

	function to_canvas (
		point 	: in type_point_model;
		scale	: in type_scale_factor;
		real	: in boolean := false) -- if real model coordinates are given
		return type_point_canvas;



	
-- DUMMY OBJECT TO BE DRAWN ON THE CANVAS:

	type type_rectangle is record
		lower_left_corner : type_point_model;
		width  : type_distance_model := bounding_box.width;
		height : type_distance_model := bounding_box.height;
	end record;
	

	object : type_rectangle;

	procedure make_object;
	
end geometry_1;

