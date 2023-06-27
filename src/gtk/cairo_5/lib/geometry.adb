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
	
end geometry;

