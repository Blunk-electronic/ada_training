-- This is a simple ada program, that
-- demonstrates a multiway tree.

-- For details see 
-- <http://www.ada-auth.org/standards/12rat/html/Rat12-8-4.html>
--
-- For correct displaying set tab width in your editor to 4.
--
--
with ada.text_io;			use ada.text_io;
with ada.strings.unbounded;	use ada.strings.unbounded;
with ada.containers;		use ada.containers;
with ada.containers.multiway_trees;


procedure demo is

	-- A single department of the enterprise
	-- has these properties:
	type type_department is record
		-- The name like "Human recources"
		-- or "machinery maintenance":
		name				: unbounded_string;

		-- The numbering where the personal id
		-- of employees is based on:
		employee_id_base	: natural;
	end record;

	
	function to_string (
		department : in type_department)
		return string
	is begin
		return ("name: " & to_string (department.name)
			& ". base:" & natural'image (department.employee_id_base));
	end to_string;


	function create_department (
		name : in string;
		base : in natural)
		return type_department
	is begin
		return (to_unbounded_string (name), base);
	end create_department;


	-- Instantiate the multiway package:
	package pac_enterprise_structure is new 
		multiway_trees (type_department);

	use pac_enterprise_structure;


	-- Create the company structure as a tree.
	-- For better understanding, imagine the tree upside-down
	-- with its root on top and departments, sub-departments
	-- and sub-sub-departments below:
	structure : pac_enterprise_structure.tree;

	-- This cursor points to a node in the tree.
	-- We initialize it right away so that it points
	-- to the root of the tree:
	cursor : pac_enterprise_structure.cursor := root (structure);
											
	-- 1. Each department is a so called "node".
	-- 2. A department can have one or more sub-departments
	--    which are so called "child nodes".
	-- 3. Nodes having the same parent are called "siblings".
	-- 4. If a node has no children then we call it a "leaf node"
	-- 5. One node is the root of the tree. It is something
	--    madatory but is does not have an element.
	-- 6. The root has a single child as the first and topmost
	--    item in the tree. In in our example of an
	--    enterprise this would be the executive board.
begin
	put_line ("demo");
	
	-- Create the first node, the "executive board":
	structure.insert_child (
		parent 		=> cursor, -- the root as input
		before		=> no_element,
		new_item	=> create_department ("executive board", 1),
		position	=> cursor); -- the node as output

	-- So cursor now points to the node that has
	-- just been created:
	put_line (to_string (element (cursor)));


end demo;
