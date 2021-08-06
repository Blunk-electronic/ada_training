-- This is a simple ada program,
-- that shows an approach on how to round
-- decimal fixed point types.

with ada.text_io;	use ada.text_io;

procedure types_fixed_point_6 is

	digit_count : constant := 10;
	range_min : constant := -100.0;
	range_max : constant := +100.0;	
	step_width : constant := 0.0001;
	
	type type_distance is delta step_width
		digits digit_count 
		range range_min .. range_max;

	step_width_coarse : constant := type_distance'small * 10.0;
	type type_distance_coarse is delta step_width_coarse 
		digits type_distance'digits - 1
		range type_distance'first .. type_distance'last;

	
	function round (d_fine : in type_distance) return type_distance_coarse is
		d_coarse : type_distance_coarse := type_distance_coarse (d_fine);
		d_delta : type_distance;
	begin
		d_delta := abs (d_fine) - abs (type_distance (d_coarse));
		
		if d_delta >= 5.0 * step_width then
			if d_fine > 0.0 then
				d_coarse := d_coarse + step_width_coarse;
			else
				d_coarse := d_coarse - step_width_coarse;
			end if;
		end if;

		return d_coarse;
	end round;

	
	A, B, C : type_distance := -0.0021;
	--F : float := 0.055;
	--F : float := 0.0714;
begin
	--put_line ("small  " & type_distance'image (type_distance'small));
	--put_line ("digits " & natural'image (type_distance'digits));
	
	--put_line (float'image (F));

	--C := type_distance (F);

	
	put_line ("C " & type_distance'image (C)); 
	put_line ("R " & type_distance_coarse'image (round (C)));

	
	for i in 1..40 loop
		new_line;

		A := A + step_width;

		put_line ("A " & type_distance'image (A)); 
		put_line ("R " & type_distance_coarse'image (round (A)));
	end loop;
	
end types_fixed_point_6;
