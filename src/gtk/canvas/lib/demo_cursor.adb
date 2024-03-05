------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                                CURSOR                                    --
--                                                                          --
--                                B o d y                                   --
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

with ada.text_io;				use ada.text_io;

with demo_visible_area;
with demo_grid;
with demo_canvas;
with demo_coordinates_display;	use demo_coordinates_display;



package body demo_cursor is

	procedure move_cursor (
		destination : type_vector_model)
	is
	begin
		cursor.position := destination;
		update_cursor_coordinates;
		update_distances_display;
		
		-- Output the cursor position on the terminal:
		put_line ("position " & to_string (cursor.position));
	end move_cursor;



	procedure move_cursor (
		direction : type_direction)
	is 
		use demo_visible_area;
		use demo_grid;
		use demo_canvas;
	begin
		-- Move the cursor by the grid spacing into the given direction:
		put_line ("move cursor " & type_direction'image (direction));
		
		case direction is
			when DIR_RIGHT =>
				cursor.position.x := cursor.position.x + grid.spacing.x;

			when DIR_LEFT =>
				cursor.position.x := cursor.position.x - grid.spacing.x;

			when DIR_UP =>
				cursor.position.y := cursor.position.y + grid.spacing.y;

			when DIR_DOWN =>
				cursor.position.y := cursor.position.y - grid.spacing.y;
		end case;


		-- If the cursor is outside the visible area, then the
		-- canvas must be shifted with the cursor:
		if not in_area (cursor.position, visible_area) then
			put_line ("cursor not in visible area");

			case direction is
				when DIR_RIGHT =>
					-- If the cursor is right of the visible area,
					-- then shift the canvas to the right:
					if cursor.position.x > visible_area.position.x + visible_area.width then
						shift_canvas (direction, grid.spacing.x);
					end if;
					
				when DIR_LEFT =>
					-- If the cursor is left of the visible area,
					-- then shift the canvas to the left:
					if cursor.position.x < visible_area.position.x then
						shift_canvas (direction, grid.spacing.x);
					end if;
					
				when DIR_UP =>
					-- If the cursor is above of the visible area,
					-- then shift the canvas up:
					if cursor.position.y > visible_area.position.y + visible_area.height then
						shift_canvas (direction, grid.spacing.y);
					end if;

				when DIR_DOWN =>
					-- If the cursor is below of the visible area,
					-- then shift the canvas down:
					if cursor.position.y < visible_area.position.y then
						shift_canvas (direction, grid.spacing.y);
					end if;

			end case;

		end if;
			
		refresh (canvas);		
		
		update_cursor_coordinates;
		update_distances_display;

		-- Output the cursor position on the terminal:
		put_line ("cursor at " & to_string (cursor.position));

		backup_visible_area (get_visible_area (canvas));
	end move_cursor;
	
	
	
end demo_cursor;

