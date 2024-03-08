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

with glib;						use glib;

with demo_logical_pixels;		use demo_logical_pixels;
with demo_geometry;				use demo_geometry;

package demo_grid is

	
	-- The grid helps the operator to align or place objects:
	type type_grid_on_off is (GRID_ON, GRID_OFF);
	type type_grid_style is (STYLE_DOTS, STYLE_LINES);

	-- The linewidth of the grid lines:
	grid_width_lines : constant gdouble := 0.5;

	-- The linewidth of the circles which form the grid dots:
	grid_width_dots : constant gdouble := 1.0;
	grid_radius_dots : constant gdouble := 0.5;

	
	-- The arm length of a grid point if drawn as a cross:
	grid_cross_arm_length : constant gdouble := 1.0;
	

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




	-- This function returns the space between
	-- the grid columns or rows. It returns the lesser
	-- spacing of them. It calculates the spacing by this
	-- equation:
	-- x = grid.spacing.x * scale-factor
	-- y = grid.spacing.y * scale-factor
	-- Then the lesser one, either x or y will be returned:
	function get_grid_spacing (
		grid : in type_grid)
		return gdouble;

	
end demo_grid;

