-- This is a simple ada program, that demonstrates character mapping.

with ada.text_io;				use ada.text_io;
with ada.strings; 				use ada.strings;
with ada.strings.maps;			use ada.strings.maps;
with ada.strings.bounded;       use ada.strings.bounded;

procedure character_mapping_1 is

	package type_string is new generic_bounded_length (100);
	use type_string;
	bs : type_string.bounded_string := to_bounded_string ("/home/user/.config/test.txt");
	
	characters : character_mapping := to_mapping ("./","_#");
begin
	put_line ("before: " & to_string (bs));
	translate (bs, characters);

	put_line ("now   : " & to_string (bs));
	
end character_mapping_1;
