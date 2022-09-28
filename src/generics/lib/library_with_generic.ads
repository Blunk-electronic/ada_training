---------------------------------
--                             --
--      library_with_generic   --
--                             --
--         S p e c             --
---------------------------------

package library_with_generic is

	generic
		type item is private;
		--type item is (<>); -- try this
	procedure swap_items(x,y : in out item);

end library_with_generic;
