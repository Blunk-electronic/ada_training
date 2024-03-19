------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                             BOUNDING BOX                                 --
--                                                                          --
--                                S p e c                                   --
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


-- NOTE: This package is about the global bounding-box and
-- 		 - related global variables
--		 - related subprograms

with demo_geometry;				use demo_geometry;


package demo_bounding_box is


	-- The safety frame around all model objects
	-- is regarded as part of the model and thus inside
	-- the bounding-box.
	-- The safety frame has a margin:
	margin : constant type_distance_model_positive := 5.0;

	
	-- This is the bounding-box of the model. It is a rectangle
	-- that encloses all objects of the model and the margins 
	-- around the model:
	bounding_box : type_area;

	
	-- These are the system limits for the width and height
	-- of the bounding-box of the model:
	bounding_box_width_max  : constant 
		type_distance_model_positive := 2_000.0;
	
	bounding_box_height_max : constant 
		type_distance_model_positive := 1_000.0;
	



	
	-- Indicates that the bounding_box has changed after calling procedure 
	-- compute_bounding_box:
	bounding_box_changed : boolean := false;

	
	-- In order to handle bouding-box related errors this 
	-- composite type is required:
	type type_bounding_box_error is record
		size_exceeded	: boolean := false;
		width			: type_distance_model_positive := 0.0;
		height			: type_distance_model_positive := 0.0;
		-- CS ? position : type_vector_model;
	end record;


	-- Here we store bounding-box related errors:
	bounding_box_error : type_bounding_box_error;


	
	-- This procedure parses the whole database of model objects
	-- and the primitive objects of the drawing frame,
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
		abort_on_first_error	: in boolean := false; 
		-- CS currently not implemented
		
		ignore_errors			: in boolean := false;
		test_only				: in boolean := false);
	
	
end demo_bounding_box;

