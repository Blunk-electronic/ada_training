-- This demo shows how to use generic child packages
-- which are in separate files.

with generic_pac_text;
with generic_pac_text.generic_child_pac_fonts;

procedure generics_8 is

	-- Instantiation of the parent package:
	package pac_text is new generic_pac_text (positive);
	size : pac_text.type_text_size := 3;

	-- Instantiation of the child package:
	package pac_fonts is new pac_text.generic_child_pac_fonts;
	-- use pac_fonts;
begin
	pac_text.write ("hello");
	pac_fonts.set_font (pac_fonts.ITALIC, size);
	-- set_font (ITALIC, size);

end generics_8;
