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
		point	: in type_point_model)
		return string
	is begin
		return "model x/y: " & type_distance_model'image (point.x) 
			& "/" & type_distance_model'image (point.y);
	end to_string;


	function to_string (
		point	: in type_point_canvas)
		return string
	is begin
		return "canvas  x/y: " & gdouble'image (point.x) & "/" & gdouble'image (point.y);
	end to_string;


	procedure compute_bounding_box is
	begin
		bounding_box.width  := object.width;
		bounding_box.height := object.height;

		-- CS
		-- put_line ("bounding box (width/height) " 
		-- 	& to_string (bounding_box.width) & "/" & to_string (bounding_box.height));
	end compute_bounding_box;
	

	procedure compute_base_offset is
		x, y : gdouble;

		-- The maximum scale factor:
		S : constant gdouble := gdouble (type_scale_factor'last);
		By : constant gdouble := gdouble (bounding_box.height);
		Bx : constant gdouble := gdouble (bounding_box.width);
	begin
		-- x := 10.0; -- CS add formula
		x := Bx * S - Bx;
		y := - By * S;

		-- base_offset := (
		-- x => 10.0, 
		-- y => -2000.0);

		base_offset := (x, y);

		put_line ("base offset: " & to_string (base_offset));
	end compute_base_offset;

	
	
	function to_model (
		point		: in type_point_canvas;
		scale		: in type_scale_factor;
		translate	: in type_point_canvas;
		offset		: in type_point_canvas)
		return type_point_model
	is 
		result : type_point_model;
	begin
		result.x := type_distance_model (( (point.x - translate.x) - offset.x) / gdouble (scale));
		result.y := type_distance_model ((-(point.y - translate.y) - offset.y) / gdouble (scale));
		return result;
	end to_model;
	

	function to_canvas (
		point 		: in type_point_model;
		scale		: in type_scale_factor;
		offset		: in type_point_canvas)
		return type_point_canvas
	is
		result : type_point_canvas;
	begin
		result.x :=  (gdouble (point.x) * gdouble (scale) + offset.x);
		result.y := -(gdouble (point.y) * gdouble (scale) + offset.y);
		return result;
	end to_canvas;


	procedure make_object is
	begin
		object.lower_left_corner := (0.0, 0.0);
		object.width  := 400.0;
		object.height := 200.0;
	end make_object;
	
end geometry;

