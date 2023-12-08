------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                              GEOMETRY 2                                  --
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

with geometry_1;				use geometry_1;

package geometry_2 is

	-- The simplest object in the model world is a line:
	type type_line is record
		s, e : type_point_model; -- start and end point
		w : type_distance_model; -- linewidth
	end record;

	-- CS arc ?

	-- Moves a line by the given offset:
	procedure move_line (
		line	: in out type_line;
		offset	: in type_point_model);

	
	-- Returns the bounding-box of the given line.
	-- It respects the linewidth and assumes that the line ends
	-- have round caps:
	function get_bounding_box (
		line : in type_line)
		return type_area;

	
	-- Returns true if the given areas overlap each other:
	function areas_overlap (
		A, B : in type_area)
		return boolean;


	-- Merges the given area B into area A:
	procedure merge_areas (
		A : in out type_area;
		B : in type_area);
	

	-- If an object occupies a space that is wider or
	-- higher than this constant, then it will be drawn on the screen:
	visibility_threshold : constant gdouble := 5.0;
	
	-- Returns true if the given area is large enough
	-- to display objects therein:
	function above_visibility_threshold (
		a : in type_area)
		return boolean;
	
		
	-- type type_rectangle is new type_object with record
	-- 	-- The four corners of the rectangle in
	-- 	-- counter-clockwise order:
	-- 	bl : type_point_model; -- bottom left
	-- 	br : type_point_model; -- bottom right
	-- 	tr : type_point_model; -- top right
	-- 	tl : type_point_model; -- top left
	-- 	w  : type_distance_model; -- the linewidth
	-- end record;
	

	-- Another primitive object is a circle:
	type type_circle is record
		c : type_point_model;
		w : type_distance_model; -- the linewidth
		-- CS: fill status
	end record;

	
	type type_object is abstract tagged record
		p : type_point_model;
	end record;

	
	type type_complex_object is new type_object with record
		l1, l2, l3 : type_line;
		c1 : type_circle;
	end record;


	object_1 : type_complex_object := (
		p	=> (30.0, 60.0),
		l1	=> (s => (-10.0, -10.0), e => ( 10.0, -10.0), w => 5.0),
		l2	=> (s => ( 10.0, -10.0), e => ( 10.0, +10.0), w => 1.0),
		l3	=> (s => ( 10.0, +10.0), e => (-10.0, -10.0), w => 1.0),
		c1	=> (c => (0.0, 0.0), w => 2.0)
		);
	
end geometry_2;

