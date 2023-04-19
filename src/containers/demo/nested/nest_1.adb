-- This program demonstrates how to search items
-- in nested containers.

with ada.text_io; 			use ada.text_io;
with ada.containers;		use ada.containers;
with ada.containers.ordered_maps;
with ada.containers.doubly_linked_lists;
with ada.strings.bounded;	use ada.strings.bounded;

procedure nest_1 is
	
	type type_line is record
		S, E : float := 0.0;
	end record;

	function to_string (l : in type_line) return string is begin
		return "S:" & float'image (l.S) & " E:" & float'image (l.E);
	end;
	
	package pac_lines is new doubly_linked_lists (type_line);
	use pac_lines;
	----------------------------
	package pac_net_name is new generic_bounded_length (10);
	use pac_net_name;

	type type_net is record
		lines : pac_lines.list;
	end record;

	net : type_net;
	
	-----------------------------
	package pac_nets is new ordered_maps (
		key_type		=> pac_net_name.bounded_string,
		element_type	=> type_net);

	use pac_nets;
	
	nets : pac_nets.map;
	------------------------------

	-- This procedure searches for a line that starts at 2.0.
	-- The result is a cursor to the affected line.
	procedure get_line is 
		result : pac_lines.cursor;
		
		procedure query_net (n : in pac_nets.cursor) is
			net : type_net renames element (n);
			-- net : type_net := element (n);

			procedure query_line (l : in pac_lines.cursor) is begin
				-- Test the start point of the candidate line.
				-- On match, store its cursor in result:
				if element (l).S = 2.0 then -- match
					result := l;
					put_line ("L1 " & to_string (element (result)));
				end if;
			end query_line;
			
		begin
			-- iterate the lines of the candidate net:
			put_line ("net: " & to_string (key (n)));
			iterate (net.lines, query_line'access);
			-- iterate (element (n).lines, query_line'access);

			-- Output the result. 
			-- It should never change once the targeted line has been found:
			put_line ("L2 " & to_string (element (result)));
		end query_net;
		
	begin
		-- iterate the nets:
		nets.iterate (query_net'access);

		-- Output the result. 
		-- It should never change once the targeted line has been found:
		put_line ("L3 " & to_string (element (result)));
	end get_line;
		
	

begin
	-- build net A:
	net.lines.append ((0.0, 1.0));
	net.lines.append ((2.0, 3.0));
	net.lines.append ((5.0, 6.0));
	nets.insert (to_bounded_string ("A"), net);

	-- build net B:
	net.lines.clear;
	net.lines.append ((10.0, 11.0));
	net.lines.append ((12.0, 13.0));
	net.lines.append ((15.0, 16.0));
	nets.insert (to_bounded_string ("B"), net);

	get_line;
end nest_1;
