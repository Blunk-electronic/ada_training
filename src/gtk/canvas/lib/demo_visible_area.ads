------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                             VISIBLE AREA                                 --
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

-- with gtk.widget;				use gtk.widget;
-- with gtk.drawing_area;			use gtk.drawing_area;
with geometry_1;				use geometry_1;
with geometry_2;				use geometry_2;
-- with demo_window_dimensions;	use demo_window_dimensions;



package demo_visible_area is

	-- In MODE_3_ZOOM_FIT, here the last visible area
	-- immediately before the dimensions of the scrolled window
	-- change, is stored as reference.
	-- In other canvas modi it has no meaning:
	last_visible_area : type_area;


	-- This procedure takes an area and stores it in
	-- the global variable last_visible_area (see above).
	-- Its purpose is to be prepared to fit the area into the 
	-- scrolled window in MODE_3_ZOOM_FIT.
	-- It must be called after operations that result in a
	-- new visibible area. Such operations are:
	-- - scrollbar released
	-- - scroll up/down/right/left
	-- - move cursor
	-- - zoom on cursor
	-- - zoom to fit all 
	-- - zoom to fit area
	-- - zoom on mouse pointer
	-- In in other canvas modi but MODE_3_ZOOM_FIT this
	-- procedure has no meaning:
	procedure backup_visible_area (
		area : in type_area);

	
end demo_visible_area;

