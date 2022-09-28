-- The specification of a simple generic parent package.

-- You may compile it separately by running 
-- this command: gnatmake generic_pac_text
-- To clean up run: gnatclean generic_pac_text

with pac_text;  -- for non-generic things. 
-- NOTE: The parent package generic_pac_text can see it, 
-- so its children can see it too.

generic
	
	type type_size is (<>);
	
package generic_pac_text is

	w : pac_text.type_weight;
	
	subtype type_text_size is type_size;

	procedure write (t : in string);

end generic_pac_text;
