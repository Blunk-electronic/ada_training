-- This is a simple ada program,
-- demonstrates redefining of the "=" function.

with text_io;		use text_io;

procedure equality is

	type type_float is new float;

	threshold : constant type_float := 0.1;

	function to_string (f : in type_float) return string is begin
		return type_float'image (f);
	end;


	
	-- This function is overloading the predefined equals function
	-- inherited from type "float". It considers the operands "left" and "right"
	-- as equal if their distance is less or equal a certain threshold:
	function "=" (left, right : in type_float) return boolean is 
		d : type_float := abs (left - right);
	begin
		if d <= threshold then
			--put_line ("equal");
			return true;
		else
			--put_line ("not equal");
			return false;
		end if;
	end;


	function "<=" (left, right : in type_float) return boolean is 
	begin
		if left = right then
			return true;
		elsif left < right then
			return true;
		else
			return false;
		end if;
	end;
	


	X, Y : type_float := 0.0;

	
begin
	--put_line ("equality test");

	X := 1.0;
	Y := 1.01;

	if X = Y then
		put_line ("X equals Y");
	else
		put_line ("X does not equal Y");
	end if;
	
-------------------

	X := 2.0;
	
	if X <= Y then
		put_line ("X less or equal Y");
	else
		put_line ("X greater than Y");
	end if;
	
	
end equality;
