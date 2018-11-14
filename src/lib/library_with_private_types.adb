---------------------------------------
--                                   --
--      library_with_private_types   --
--                                   --
--         B o d y                   --
---------------------------------------

package body library_with_private_types is

	function take_money (c : in positive) return wealth is
		w : wealth;
	begin
		w.cash := c;
		w.estate := 0;
		w.total := c;
		return w;
	end take_money;

	function take_estate (e : in positive) return wealth is
		w : wealth;
	begin
		w.cash := 0;
		w.estate := e;
		w.total := e;
		return w;
	end take_estate;
	
	function "+" (a,b : in wealth) return wealth is 
		c : wealth;
	begin
		c.cash := a.cash + b.cash;
		c.estate := a.estate + b.estate;
		c.total := c.cash + c.estate;
		return (c);
	end "+";

	function show_wealth (w : in wealth) return natural is
	begin
		return (w.total);
	end show_wealth;
	
end library_with_private_types;
