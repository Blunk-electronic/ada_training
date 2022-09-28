-- This is a simple ada program, that
-- demonstrates the usage of a generic subprogram.

with ada.text_io; use ada.text_io;
with library_with_generic;

procedure generics_2 is

	use library_with_generic;
	procedure swap_natural is new swap_items(item => natural);
	x : natural := 10;
	y : natural :=  7;
begin
	put_line("x:" & natural'image(x) & "  y:" & natural'image(y));	
	swap_natural(x,y);
	put_line("x:" & natural'image(x) & "  y:" & natural'image(y));
	
end generics_2;
