-- This demo shows how to use generic child packages.
-- For simplicity everything is placed in a single file.

procedure generics_6 is

	-- Specification of the parent package:
	generic
		type type_size is (<>);
	package generic_pac_text is

		subtype type_text_size is type_size;
		procedure write (t : in string);

		-- Specification of a child package "at library level"
		-- inside the parent package:
		generic
		package generic_child_pac_fonts is
			type type_font is (NORMAL, ITALIC);
			procedure set_font (f : in type_font; s : in type_text_size);
		end generic_child_pac_fonts;


	end generic_pac_text;


	package body generic_pac_text is

		procedure write (t : in string) is begin null; end write;

		package body generic_child_pac_fonts is
			procedure set_font (f : in type_font; s : in type_text_size) is begin null; end;
		end generic_child_pac_fonts;

	end generic_pac_text;


	-- The following block does not compile with error message:
	-- "child unit allowed only at library level"
	-- The specification and body of the child package must be
	-- inside the parent package (see above).
	-----------------------------------------------------------
-- 	generic
-- 	package generic_pac_text.generic_child_pac_fonts is
-- 		type type_font is (NORMAL, ITALIC);
-- 		procedure set_font (f : in type_font);
-- 	end generic_pac_text.generic_child_pac_fonts;
-- 
-- 	package body generic_pac_text.generic_child_pac_fonts is
-- 		type type_font is (NORMAL, ITALIC);
-- 		procedure set_font (f : in type_font) is begin null; end set_font;
-- 	end generic_pac_text.generic_child_pac_fonts;
	-----------------------------------------------------------

	-- Instantiation of the parent package:
	package pac_text is new generic_pac_text (positive);
	size : pac_text.type_text_size := 3;

	-- Instantiation of the child package:
	package pac_fonts is new pac_text.generic_child_pac_fonts;
	--use pac_fonts;
begin
	pac_text.write ("hello");
	pac_fonts.set_font (pac_fonts.ITALIC, 4);
	--set_font (ITALIC, 4);
end generics_6;
