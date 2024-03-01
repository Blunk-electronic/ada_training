------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                                OBJECTS                                   --
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

with glib;						use glib;

with ada.numerics;
with ada.numerics.generic_elementary_functions;

with ada.containers;			use ada.containers;
with ada.containers.doubly_linked_lists;

-- with geometry_1;				use geometry_1;
with geometry_2;				use geometry_2;

package demo_objects is

	
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
		c : type_vector_model;   -- the center
		r : type_distance_model; -- the radius
		w : type_distance_model; -- the linewidth
		-- CS: fill status
	end record;

	
	-- Returns the bounding-box of the given circle.
	-- It respects the linewidth of the circumfence:
	function get_bounding_box (
		circle : in type_circle)
		return type_area;

	
	-- Moves a circle by the given offset:
	procedure move_circle (
		circle	: in out type_circle;
		offset	: in type_vector_model);

	
	-- CS arc ?



	-- An object in general has a position in x and y:
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

	
	-- This procedure generates a dummy database with 
	-- some useless dummy objects:
	procedure make_database;

	-- This procedure parses the whole database of model objects,
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


	-- This procedure adds a new object to the database.
	-- The object is a simple square:
	procedure add_object;

	
	-- This procedure deletes the last object that has been
	-- added to the database:
	procedure delete_object;



	
	

	type type_drawing_frame is new type_object with record
		lines	: pac_lines.list;
		-- CS texts
	end record;

	drawing_frame : type_drawing_frame;

	-- The place where the lower left corner of the 
	-- drawing frame frame is:
	drawing_frame_position : type_vector_model := (-150.0, -105.0);


	-- This procedure generates a very simple
	-- dummy drawing frame:
	procedure make_drawing_frame;

	
end demo_objects;

