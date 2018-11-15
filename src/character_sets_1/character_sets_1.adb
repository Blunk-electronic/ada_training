-- This is a simple ada program, that demonstrates character sets.

with ada.text_io;	
with ada.strings.maps;			use ada.strings.maps;

procedure character_sets_1 is

	char_set : character_set := to_set (span => ('A','Z')); 

	invalid_character_position : natural := 0;
begin

	begin
		invalid_character_position := index (
			source 	=> bounded_string,
			set 	=> char_set,
			test 	=> outside);
		
end character_sets_1;
