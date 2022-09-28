-- This is the body of a generic child package:

package body generic_pac_text.generic_child_pac_fonts is

	procedure set_font (
		f : in type_font;
		s : in type_text_size)
	is 
		-- pac_text is visible because the parent package
		-- generic_pac_text can see it:
		use pac_text; 
		w : type_weight := BOLD;
	begin 
		null;
	end set_font;

end generic_pac_text.generic_child_pac_fonts;
