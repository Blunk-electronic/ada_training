------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                                 GRID                                     --
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


package demo_grid is
	
	-- The grid helps the operator to align or place objects:
	type type_grid_on_off is (GRID_ON, GRID_OFF);
	type type_grid_style is (STYLE_DOTS, STYLE_LINES);

	-- The linewidth of the grid lines:
	grid_width_lines : constant type_logical_pixels_positive := 0.5;

	-- The linewidth of the circles which form the grid dots:
	grid_width_dots : constant type_logical_pixels_positive := 1.0;
	grid_radius_dots : constant type_logical_pixels_positive := 0.5;

	
	-- The arm length of a grid point if drawn as a cross:
	grid_cross_arm_length : constant type_logical_pixels_positive := 1.0;
	

	-- The default grid size in in the model domain:
	grid_spacing_default : constant type_distance_model_positive := 10.0; 
	-- use it for the example with the rectangle, triangle and circle

	-- grid_spacing_default : constant type_distance_model_positive := 100.0;
	-- use it for the bridge example
	
	-- grid_spacing_default : constant type_distance_model_positive := 1.0; 
	-- use it for the screw example

	-- If the displayed grid is too dense, then it makes no
	-- sense to draw a grid. For this reason we define a minimum
	-- distance between grid rows and columns. If the spacing becomes
	-- greater than this threshold then the grid will be drawn:
	grid_spacing_min : constant type_logical_pixels_positive := 10.0;

	
	type type_grid is record
		on		: type_grid_on_off := GRID_ON;
		-- on		: type_grid_on_off := GRID_OFF;
		spacing : type_vector_model := (others => grid_spacing_default);
		style	: type_grid_style := STYLE_DOTS;
		--style	: type_grid_style := STYLE_LINES;
	end record;

	
	-- This is the grid used by this demo program:
	grid : type_grid;


	-- This procedure sets the grid spacing
	-- according to the scale specified
	-- by the operator (see package spec. demo_scale):
	procedure set_grid_to_scale;
	
	
	-- This function returns the grid point that is
	-- closest to the given model point;
	function snap_to_grid (
		point : in type_vector_model)
		return type_vector_model;




	-- This function returns the space between
	-- the grid columns or rows. It returns the lesser
	-- spacing of them. It calculates the spacing by this
	-- equation:
	-- x = grid.spacing.x * zoom factor
	-- y = grid.spacing.y * zoom factor
	-- Then the lesser one, either x or y will be returned:
	function get_grid_spacing (
		grid : in type_grid)
		return type_logical_pixels_positive;



	-- This procedure draws the grid in the visible area.
	-- Outside the visible area nothing is drawn in order to save time.
	-- The procedure works as follows:
	-- 1. Define the begin and end of the visible area in 
	--    x and y direction.
	-- 2. Find the first column that comes after the begin of 
	--    the visible area (in x direction).
	-- 3. Find the last column that comes before the end of the 
	--    visible area (in x direction).
	-- 4. Find the first row that comes after the begin of the 
	--    visible area (in y direction).
	-- 5. Find the last row that comes before the end of the 
	--    visible area (in y direction).
	-- 6. Draw the grid as dots or lines, depending on the user specified
	--    settings.
	procedure draw_grid;

	
end demo_grid;

