-- This is a simple ada program, that
-- demonstrates the usage of a generic subprogram.

with ada.text_io; use ada.text_io;

procedure generics_1 is

	generic -- subprogram specificaton
		type item is private;
	procedure swap_items(x,y : in out item);

	procedure swap_items(x,y : in out item) is -- subprogram body
		scratch : item := x;
	begin
		x := y;    y := scratch;
	end swap_items;

	procedure swap_natural is new swap_items(item => natural);
	x : natural := 10;
	y : natural :=  7;
begin
	put_line("x:" & natural'image(x) & "  y:" & natural'image(y));	
	swap_natural(x,y);
	put_line("x:" & natural'image(x) & "  y:" & natural'image(y));
	
end generics_1;
