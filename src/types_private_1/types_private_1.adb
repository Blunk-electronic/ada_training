-- This is a simple ada program, that
-- demonstrates the NEED of a private type.

with ada.text_io; use ada.text_io;

procedure types_private_1 is

	type wealth is record
		cash, estate, total : natural := 0;
	end record;

	function "+" (a,b : in wealth) return wealth is 
		c : wealth;
	begin
		c.cash := a.cash + b.cash;
		c.estate := a.estate + b.estate;
		c.total := c.cash + c.estate;
		return (c);
	end "+";

	w, p : wealth;
	
begin
	p.cash := 8;  p.estate := 4;  w := w + p;
	
	put_line ("cash   :" & natural'image(w.cash));
	put_line ("estate :" & natural'image(w.estate));
	put_line ("total  :" & natural'image(w.total));

	w.total := 100; -- Compiles, yet it's a lie !
	
end types_private_1;
