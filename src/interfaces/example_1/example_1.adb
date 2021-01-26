-- This is a simple ada program, that demonstrates an interface type.

with ada.text_io;		use ada.text_io;
with pac_1;				use pac_1;

procedure example_1 is

	A2 : type_A2;
	B1 : type_B1;
begin

	print_p2 (A2);
	print_p2 (B1);
	
end example_1;
