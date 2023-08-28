with ada.text_io;				use ada.text_io;
with glib;						use glib;

package body geometry is

	function to_string (
		scale : in type_scale_factor)
		return string
	is begin
		return "scale: " & type_scale_factor'image (scale);
	end to_string;
	
	
	procedure increase_scale is begin
		scale_factor := scale_factor * scale_increment;
		
		exception 
			when constraint_error =>
				put_line ("upper scale limit reached");
			when others => null;
	end increase_scale;

	
	procedure decrease_scale is begin
		scale_factor := scale_factor / scale_increment;
		
		exception 
			when constraint_error => 
				put_line ("lower scale limit reached");
			when others => null;
	end decrease_scale;


	function to_string (
		distance : in type_distance_model)
		return string
	is begin
		return type_distance_model'image (distance);
	end to_string;

	
	function to_string (
		point	: in type_point_model)
		return string
	is begin
		return "model x/y: " & to_string (point.x) & "/" & to_string (point.y);
	end to_string;


	function invert (
		point	: in type_point_model)
		return type_point_model
	is begin
		return (- point.x, - point.y);
	end invert;

	

	procedure move_by (
		point	: in out type_point_model;
		offset	: in type_point_model)
	is begin
		point.x := point.x + offset.x;
		point.y := point.y + offset.y;
	end move_by;

	

	function to_string (
		point	: in type_point_canvas)
		return string
	is begin
		return "canvas  x/y: " & gdouble'image (point.x) & "/" & gdouble'image (point.y);
	end to_string;


	procedure compute_bounding_box is
	begin
		-- Add to the object dimensions the margin. 
		-- The margin is part of the model and thus part 
		-- of the bounding box:
		bounding_box.width  := object.width  + 2.0 * margin;
		bounding_box.height := object.height + 2.0 * margin;
		
		put_line ("bounding box (width/height) " 
			& to_string (bounding_box.width) & "/" & to_string (bounding_box.height));

		-- Compute the position of the bounding-box.
		-- This is the smallest x and y value used by the objects:
		bounding_box.position := object.lower_left_corner;
	end compute_bounding_box;
	

	procedure compute_base_offset is
		x, y : gdouble;

		-- The maximum scale factor:
		S : constant gdouble := gdouble (type_scale_factor'last);
		By : constant gdouble := gdouble (bounding_box.height);
		Bx : constant gdouble := gdouble (bounding_box.width);
	begin
		x :=   Bx * S - Bx;
		y := - By * S;

		base_offset := (x, y);

		put_line ("base offset: " & to_string (base_offset));
	end compute_base_offset;

	
	
	function to_model (
		point	: in type_point_canvas;
		scale	: in type_scale_factor;
		real 	: in boolean := false)
		return type_point_model
	is 
		result : type_point_model;
	begin
		result.x := type_distance_model (( (point.x - translate_offset.x) - base_offset.x) / gdouble (scale));
		result.y := type_distance_model ((-(point.y - translate_offset.y) - base_offset.y) / gdouble (scale));

		-- If real coordinates are required, then the result must be compensated
		-- (or "moved back") by the margin_offset and the bounding-box position:
		if real then
			move_by (result, invert (margin_offset));
			move_by (result, bounding_box.position);
		end if;
		return result;
	end to_model;
	

	function to_canvas (
		point 	: in type_point_model;
		scale	: in type_scale_factor;
		real	: in boolean := false)
		return type_point_canvas
	is
		P : type_point_model := point;
		result : type_point_canvas;
	begin
		if real then
			move_by (P, invert (bounding_box.position));
			move_by (P, margin_offset);
		end if;
		
		result.x :=  (gdouble (P.x) * gdouble (scale) + base_offset.x);
		result.y := -(gdouble (P.y) * gdouble (scale) + base_offset.y);

		if real then
			result.x := result.x + translate_offset.x;
			result.y := result.y + translate_offset.y;
		end if;
		
		return result;
	end to_canvas;

	

	procedure make_object is
	begin
		object.lower_left_corner := (-10.0, -5.0);
		-- object.width  := 400.0;
		-- object.height := 200.0;
		
		-- object.lower_left_corner := (5.0, 5.0);
		object.width  := 390.0;
		object.height := 190.0;
	end make_object;
	
end geometry;

