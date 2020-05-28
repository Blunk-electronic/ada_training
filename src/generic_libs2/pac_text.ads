-- A simple generic package.

-- You may compile it separately by running this command: gnatmake generic_pac_text
-- To clean up run: gnatclean generic_pac_text

package pac_text is

	generic
		
		type type_size is (<>);
		
	package generic_pac_text is

		subtype type_text_size is type_size;

		procedure write (t : in string);

	end generic_pac_text;

end pac_text;
