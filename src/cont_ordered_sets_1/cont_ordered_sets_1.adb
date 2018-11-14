-- This is a simple ada program, that
-- demonstrates an ordered set.

with ada.text_io; use ada.text_io;
with ada.containers; use ada.containers;
with ada.containers.ordered_sets;

procedure cont_ordered_sets_1 is
	package type_my_list is new ordered_sets (natural);
	use type_my_list;
	l : type_my_list.set;
	c : type_my_list.cursor;
begin
	insert(l,7); -- append object '7' to list 'l'
	insert(l,2); -- append object '9' to list 'l'

	c := l.first;
	put_line (natural'image (element (c))); -- 2
	next (c);
	put_line (natural'image (element (c)));	-- 7
end cont_ordered_sets_1;
