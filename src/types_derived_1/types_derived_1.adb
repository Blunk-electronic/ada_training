-- This is a simple ada program,
-- demonstrates a derived type.

with ada.text_io;	use ada.text_io;

procedure types_derived_1 is
	i : integer := 2;

	-- This is a new type my_own_float. 
	-- It is not compatible with type float,
	-- but inherits primitive operations defined
	-- for type float:
	type my_own_float is new float range 1.5 .. 5.0;
	mf	: my_own_float := 2.0;
begin
	mf := mf * 2.0;
	put_line(my_own_float'image(mf));

	 -- mf := mf + i; -- does not compile
end types_derived_1;
