----------------------------------
--                              --
--      library_with_generic    --
--                              --
--         B o d y              --
----------------------------------

package body library_with_generic is

	procedure swap_items(x,y : in out item) is
		scratch : item := x;
	begin
		x := y;    y := scratch;
	end swap_items;
	
end library_with_generic;