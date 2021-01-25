-- This is a simple ada program, that demonstrates an interface type.

--with ada.text_io;	use ada.text_io;

procedure interfaces_1 is

	type type_enum is (LOW, MIDDLE, HIGH);
	
	type type_base is tagged record
		p0 : natural := 0;
	end record;

	
	type type_A1 is new type_base with record
		p1 : boolean := false;
	end record;

	type type_A2 is new type_A1 with record
		p2 : type_enum := MIDDLE;
	end record;


	type type_B1 is new type_base with record
		p2 : type_enum := MIDDLE;
	end record;
	
	
begin
	null;	
end interfaces_1;
