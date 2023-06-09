with glib;						use glib;

package body geometry is


	function to_string (
		point	: in type_point_model)
		return string
	is begin
		return "model x/y: " & float'image (point.x) & "/" & float'image (point.y);
	end to_string;


	function to_string (
		point	: in type_point_canvas)
		return string
	is begin
		return "canvas  x/y: " & gdouble'image (point.x) & "/" & gdouble'image (point.y);
	end to_string;


	function to_model (
		point		: in type_point_canvas;
		scale		: in gdouble;
		translate	: in type_point_canvas)
		return type_point_model
	is 
		result : type_point_model;
	begin
		result.x := float (( (point.x - translate.x) - offset.x) / scale);
		result.y := float ((-(point.y - translate.y) - offset.y) / scale);
		return result;
	end to_model;
	

	function to_canvas (
		point 		: in type_point_model;
		scale		: in gdouble)
		return type_point_canvas
	is
		result : type_point_canvas;
	begin
		result.x :=  (gdouble (point.x) * scale + offset.x);
		result.y := -(gdouble (point.y) * scale + offset.y);
		return result;
	end to_canvas;


	function to_string (
		scale : in gdouble)
		return string
	is begin
		return "scale: " & gdouble'image (scale);
	end to_string;
	
	
	procedure increase_scale is 
	begin
		scale_factor := scale_factor * scale_increment;
	end increase_scale;
	
	procedure decrease_scale is 
	begin
		scale_factor := scale_factor / scale_increment;
	end decrease_scale;

	
end geometry;

