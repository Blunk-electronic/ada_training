-- This is a simple ada program,
-- demonstrates redefining of the "=" function.

with text_io;		use text_io;

procedure equality is

	type type_float is new float;

	threshold : constant type_float := 0.1;

	function to_string (f : in type_float) return string is begin
		return type_float'image (f);
	end;


	-- In order to have access to the predefined "=" function
	-- we rename it:
	function equal (left, right : in type_float) return boolean renames "=";

	
	-- This function is overloading the predefined equals function
	-- inherited from type "float". It considers the operands "left" and "right"
	-- as equal if their distance is less or equal a certain threshold:
	function "=" (left, right : in type_float) return boolean is 
		d : type_float := abs (left - right);
	begin
		new_line;
		put_line ("testing float:");
		put_line ("left     : " & to_string (left));
		put_line ("right    : " & to_string (right));
		put_line ("delta    : " & to_string (d));
		put_line ("threshold: " & to_string (threshold));

	
		if d <= threshold then
			--put_line ("equal");
			return true;
		else
			--put_line ("not equal");
			return false;
		end if;
	end;

	

	
	type type_point is record
		x, y : type_float := 0.0;
	end record;

	
	function to_string (p : in type_point) return string is begin
		return "x:" & to_string (p.x) & " y:" & to_string (p.y);
	end to_string;


	-- This is the function that test two points for equality.
	-- It bases on the "=" function that tests type_float for equality:
	function "=" (left, right : in type_point) return boolean is begin
		new_line;
		put_line ("testing points:");
		put_line ("left     : " & to_string (left));
		put_line ("right    : " & to_string (right));

		if left.x = right.x and
		   left.y = right.y
		then
			--put_line ("points are equal");
			return true;
		else
			--put_line ("points are not equal");
			return false;
		end if;
	end;

	
	
	type type_line is record
		start_point, end_point : type_point;
	end record;

	function to_string (l : in type_line) return string is begin
		return "start:" & to_string (l.start_point) & " end:" & to_string (l.end_point);
	end;

	X, Y : type_float := 0.0;
	p1, p2 : type_point;
	line_1, line_2 : type_line;
	
begin
	--put_line ("equality test");

	X := 1.0;
	Y := 1.01;

	--if X = Y then -- uses the predefined equality test
	--if equal (X, Y) then -- uses the original equality test
	if standard."=" (X, Y) then
		put_line ("X equals Y");
	else
		put_line ("X does not equal Y");
	end if;
	
-------------------

	--p1 := (1.0, 0.0);
	--p2 := (1.01, 0.0);

	--if p1 = p2 then
		--put_line ("point 1 equals point 2");
	--else
		--put_line ("point 1 does not equal point 2");
	--end if;
	
-------------------
	
	--line_1 := ((0.0, 0.0), (1.0, 1.0));
	----line_2 := ((0.11, 0.0), (1.0, 1.0)); -- not equal line_1
	--line_2 := ((0.1, 0.0), (1.0, 1.0)); -- equals line_1

	--if line_1 = line_2 then
		--put_line ("line 1 equals line 2");
	--else
		--put_line ("line 1 does not equal line 2");
	--end if;
	
end equality;
