-- This is a simple ada program, that demonstrates character sets.

with ada.text_io;				use ada.text_io;
with ada.strings; 				use ada.strings;
with ada.strings.maps;			use ada.strings.maps;
with ada.strings.bounded;       use ada.strings.bounded;

procedure character_sets_1 is

	package type_string is new generic_bounded_length (100);
	use type_string;
	bs : type_string.bounded_string := to_bounded_string ("AB-C");
	
	--char_set : character_set := to_set (span => ('A','Z')); 
	char_set : character_set := to_set (ranges => (('A','Z'),('a','z')));

	invalid_character_position : natural := 0;
begin

	invalid_character_position := index (
		source 	=> bs,
		set 	=> char_set,
		test 	=> outside);

	if invalid_character_position > 0 then
		put_line ("invalid character at position" 
			& natural'image (invalid_character_position) & " !");
	end if;
end character_sets_1;
