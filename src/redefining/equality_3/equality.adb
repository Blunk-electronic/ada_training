-- This is a simple ada program,
-- demonstrates redefining of the "=" function.

with text_io;		use text_io;

procedure equality is

	type type_float is new float;

	threshold : constant type_float := 0.01;

	function to_string (f : in type_float) return string is begin
		return type_float'image (f);
	end;


	
	-- This function is overloading the predefined equals function
	-- inherited from type "float". It considers the operands "left" and "right"
	-- as equal if their distance is less or equal the threshold:
	function "=" (left, right : in type_float) return boolean is 
		d : type_float := abs (left - right);
	begin
		put_line ("redefinded '=' function");
		put_line ("left      : " & to_string (left));
		put_line ("right     : " & to_string (right));
		put_line ("delta     : " & to_string (d));
		put_line ("threshold : " & to_string (threshold));
		
		if d <= threshold then
			--put_line ("equal");
			return true;
		else
			--put_line ("not equal");
			return false;
		end if;
	end;




	X, Y : type_float := 0.0;

	
begin

	X := 0.0;
	Y := 0.01;

	put_line ("equality test");
	
	if X = Y then
		put_line (" X equals Y");
	else
		put_line (" X does not equal Y");
	end if;
	
	new_line;


	
	put_line ("non-equality test");

	-- The '/=' test also uses the redefinded '=' test:
	if X /= Y then
		put_line (" X does not equal Y");
	else
		put_line (" X equals Y");
	end if;

	
	
end equality;
