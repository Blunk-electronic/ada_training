-- The specfication of a simple generic child package.

-- You may compile it separately by running 
-- this command: gnatmake generic_pac_text-generic_child_pac_fonts

-- To clean up run: gnatclean generic_pac_text-generic_child_pac_fonts

generic

package generic_pac_text.generic_child_pac_fonts is

	type type_font is (NORMAL, ITALIC);

	procedure set_font (
		f : in type_font;
		s : in type_text_size); -- type_text_size defined in parent

end generic_pac_text.generic_child_pac_fonts;
