-- This is a simple ada program, that
-- demonstrates the purpose of a 
-- private type.

with ada.text_io; use ada.text_io;
with library_with_private_types; use library_with_private_types;

procedure types_private_2 is

	w, p : wealth;
	
begin
	w := take_money(8);
	p := take_estate(4);
 	w := w + p;

	put_line ("total  :" & natural'image(show_wealth(w)));
	
	-- w.total := 100; -- does not compile
	
end types_private_2;
