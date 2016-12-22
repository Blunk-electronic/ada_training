-- This simple ada program demonstrates simple 
-- mathematic operations.

with ada.text_io;	use ada.text_io;
with ada.numerics.generic_elementary_functions;

procedure operations_math_1 is

	package functions is new 
		ada.numerics.generic_elementary_functions (float);
	n : float := 16.0;
begin
	put_line ("n1 squared equals " & float'image(n ** 2));
	put_line ("The square root of n equals" &
		float'image(functions.sqrt(n)));
 	put_line ("Log-base-2 of n equals" &
		float'image(functions.log(base => 2.0, x => n)));
 	put_line ("Sine of n equals" &
		float'image(functions.sin(x => n, cycle => 360.0)));
end operations_math_1;
