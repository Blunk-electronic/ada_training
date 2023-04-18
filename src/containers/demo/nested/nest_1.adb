with ada.text_io; 			use ada.text_io;
with ada.containers;		use ada.containers;
with ada.containers.ordered_maps;
with ada.containers.doubly_linked_lists;
with ada.strings.bounded;	use ada.strings.bounded;

procedure nest_1 is
	
	type type_line is record
		S, E : float := 0.0;
	end record;

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


begin
	net.lines.append ((0.0, 1.0));
	net.lines.append ((2.0, 3.0));
	net.lines.append ((5.0, 6.0));

	nets.insert (to_bounded_string ("A"), net);


end nest_1;
