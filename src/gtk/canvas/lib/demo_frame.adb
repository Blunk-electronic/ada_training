------------------------------------------------------------------------------
--                                                                          --
--                              DEMO CANVAS                                 --
--                                                                          --
--                             DRAWING FRAME                                --
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

with cairo;

with demo_canvas;
with demo_primitive_draw_ops;


package body demo_frame is

	
	procedure make_drawing_frame is
		use pac_lines;

		-- This simple drawing frame consists of lines
		-- which have a linewidth of 1mm:
		line : type_line;
		w : type_distance_model := 1.0;

		c1, c2, c3, c4 : type_vector_model;
	begin
		put_line ("make_drawing_frame");

		-- FRAME POSITION:
		
		-- Set the position of the frame (lower left corner):
		drawing_frame.position := drawing_frame_position;
		
		put_line (" frame position:" & to_string (drawing_frame.position));

		-- PRIMITIVE OBJECTS:

		-- IMPORTANT: The primitve objects are defined as if
		-- the frame were placed on position (0;0).
		-- When the frame is drawn on the canvas or when
		-- the bounding-box is computed, then the primitve
		-- objects are moved by the frame position (see assignment above).
		
		-- These are the four lines that make the 
		-- main rectangle (landscape format):

		-- The dimensions adapt to the paper size and margin:
		c1 := (margin, margin);
		c2 := (paper.width - margin, margin);
		c3 := (paper.width - margin, paper.height - margin);
		c4 := (margin, paper.height - margin);
		
		line := (s => c1, e => c2, w => w);
		drawing_frame.lines.append (line);
		
		line := (s => c2, e => c3, w => w);		
		drawing_frame.lines.append (line);

		line := (s => c3, e => c4, w => w);
		drawing_frame.lines.append (line);

		line := (s => c4, e => c1, w => w);
		drawing_frame.lines.append (line);


		
		-- The lines of the title block:
		line := (s => (200.0, margin), e => (200.0, 50.0), w => w);
		drawing_frame.lines.append (line);

		line := (s => (230.0, margin), e => (230.0, 50.0), w => w);
		drawing_frame.lines.append (line);

		
		line := (s => (200.0, 50.0), 
				 e => (paper.width - margin, 50.0), w => w);
		drawing_frame.lines.append (line);

		line := (s => (200.0, 40.0), 
				 e => (paper.width - margin, 40.0), w => w);
		drawing_frame.lines.append (line);
		
	end make_drawing_frame;



	procedure draw_drawing_frame is
		use cairo;
		use demo_canvas;
		use demo_primitive_draw_ops;
		use pac_lines;
					

		procedure query_line (lc : in pac_lines.cursor) is
			-- The candidate line being handled:
			line : type_line renames element (lc);
		begin
			--put_line ("query_line");
			
			-- Usually the drawing frame has lines with different
			-- widths. For this reason each line is drawn with 
			-- an explicit stroke:
			draw_line (line, drawing_frame.position, true);
		end query_line;

		
	begin
		--put_line ("draw_drawing_frame");

		-- Set the color:
		set_source_rgb (context, 0.5, 0.5, 0.5); -- gray

		drawing_frame.lines.iterate (query_line'access);
		-- CS iterate the lines of the title block separtely ?
		
		-- CS texts

		
	end draw_drawing_frame;

	
end demo_frame;

