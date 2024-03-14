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


-- with ada.numerics;
-- with ada.numerics.generic_elementary_functions;

with ada.containers;			use ada.containers;
with ada.containers.doubly_linked_lists;

with demo_geometry;				use demo_geometry;

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
		position : type_vector_model;
	end record;

	

	package pac_lines is new doubly_linked_lists 
		(element_type => type_line);
		
	package pac_circles is new doubly_linked_lists 
		(element_type => type_circle);
	
	type type_complex_object is new type_object with record
		lines	: pac_lines.list;
		circles	: pac_circles.list;
	end record;

	package pac_objects is new doubly_linked_lists 
		(element_type => type_complex_object);
	
	objects_database : pac_objects.list;

	
	-- This procedure generates a dummy database with 
	-- some useless dummy objects:
	procedure make_database;


	-- This procedure adds a new object to the database.
	-- The object is a simple square:
	procedure add_object;

	
	-- This procedure deletes the last object that has been
	-- added to the database:
	procedure delete_object;

	
end demo_objects;

