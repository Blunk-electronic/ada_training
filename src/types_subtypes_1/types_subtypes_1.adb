-- This is a simple ada program,
-- demonstrates a subtype.

with ada.text_io;	use ada.text_io;

procedure types_subtypes_1 is
	subtype my_integer_type is integer range -5..+5;
	i	: my_integer_type;
begin
	i := -5;
	--i := i - 1; -- compiles with warning. raises
				-- constraint error at run time
end types_subtypes_1;
