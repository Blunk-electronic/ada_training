---------------------------------------
--                                   --
--      library_with_private_types   --
--                                   --
--         S p e c                   --
---------------------------------------

package library_with_private_types is

	type wealth is private;
	function take_money  (c : in positive) return wealth;
	function take_estate (e : in positive) return wealth;
	function "+" (a,b : in wealth) return wealth;
	function show_wealth (w : in wealth) return natural;	
	
	private
		type wealth is record
			cash : natural := 0;
			estate : natural := 0;
			total : natural := 0;
		end record;

end library_with_private_types;