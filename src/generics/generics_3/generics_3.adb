-- This is a simple ada program, that
-- demonstrates the usage of a generic subprogram.

with ada.text_io; use ada.text_io;
with ada.strings.unbounded; use ada.strings.unbounded;
with library_with_generic;

procedure generics_3 is

	use library_with_generic;
	procedure swap_unbounded is new swap_items(item => unbounded_string);
	x : unbounded_string := to_unbounded_string("ABC");
	y : unbounded_string := to_unbounded_string("XYZ");
	
begin
	put_line("x:" & to_string(x) & "  y:" & to_string(y));
	swap_unbounded(x,y);
	put_line("x:" & to_string(x) & "  y:" & to_string(y));
	
end generics_3;
