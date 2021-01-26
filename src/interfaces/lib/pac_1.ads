package pac_1 is

	type type_enum is (LOW, MIDDLE, HIGH);

	--type type_C is record
		--p2 : type_enum := MIDDLE;
	--end record;

	type p2_interface is interface;
	function p2 (object : p2_interface) return type_enum is abstract;
	procedure print_p2 (object : p2_interface'class);

	
	type type_base is tagged record
		p0 : natural := 0;
	end record;


	
	type type_A1 is new type_base with record
		p1 : boolean := false;
	end record;

	type type_A2 is new type_A1 and p2_interface with private;
	overriding function p2 (object : type_A2) return type_enum;

	type type_B1 is new type_base and p2_interface with private;
	overriding function p2 (object : type_B1) return type_enum;

	
	

private

	type type_A2 is new type_A1 and p2_interface with null record;
	type type_B1 is new type_base and p2_interface with null record;
		
end pac_1;
