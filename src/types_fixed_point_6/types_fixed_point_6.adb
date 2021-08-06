-- This is a simple ada program,
-- that demonstrates an issue with decimal fixed point types.

with ada.text_io;	use ada.text_io;

procedure types_fixed_point_6 is

	digit_count : constant := 10;
	range_min : constant := -100.0;
	range_max : constant := +100.0;	
	step_width : constant := 0.0001;
	
	type type_distance is delta step_width digits digit_count 
		range range_min .. range_max;


	
	function round (d_fine : in type_distance) return type_distance is
		
		step_width_coarse : constant := step_width * 10.0;
		type type_distance_coarse is delta step_width_coarse 
			digits digit_count - 1
			range range_min .. range_max;

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

		return type_distance (d_coarse);
	end round;

	
	A, B, C : type_distance := -0.0021;
begin

	A := 0.0002;
	B := 0.0003;

	C := (A + B) / 2.0;
	
	put_line ("C " & type_distance'image (C)); 
	put_line ("R " & type_distance'image (round (C)));

	
	--for i in 1..40 loop
		--new_line;
		----put_line (float'image (f));

		--A := A + step_width;

		--put_line ("A " & type_distance'image (A)); 
		--put_line ("R " & type_distance'image (round (A)));

		
		----f := f * 1.3;
	--end loop;
	
end types_fixed_point_6;
