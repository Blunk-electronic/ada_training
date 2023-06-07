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
		scale		: in gdouble;
		translate	: in type_point_canvas)
		return type_point_canvas
	is
		result : type_point_canvas;
	begin
		result.x :=  (gdouble (point.x) * scale + offset.x) + translate.x;
		result.y := -(gdouble (point.y) * scale + offset.y) + translate.y;
		return result;
	end to_canvas;

	
	
	procedure increase_scale is 
		m : constant gdouble := 2.0;
	begin
		scale_old := scale;
		scale := scale * m;
	end increase_scale;
	
	procedure decrease_scale is 
		m : constant gdouble := 2.0;
	begin
		scale_old := scale;
		scale := scale / m;
	end decrease_scale;



	-- Translates from model x-coordinate to canvas coordinate:	
	function x_to_canvas (
		x : in gdouble)
		return gdouble
	is
		result : gdouble;
	begin
		--result := x + (offset_x * scale_x);
		--result := (x + offset_x) * scale;
		result := (x * scale + offset_x);
		--result := (x * scale + offset_x) + translate_x;
		return result;
	end x_to_canvas;
		
	-- Translates from model y-coordinate to canvas coordinate:	
	function y_to_canvas (
		y : in gdouble)
		return gdouble
	is
		result : gdouble;
	begin
		-- result := - (y + (offset_y * scale_y));
		-- result := -(y + offset_y) * scale;
		result := -(y * scale + offset_y);
		-- result := -(y * scale + offset_y) + translate_y;
		return result;
	end y_to_canvas;

	

	-- Translates from canvas x-coordinate to model coordinate:
	function x_to_model (
		x : in gdouble)
		return gdouble
	is
		result : gdouble;
	begin
		--result := x - (offset_x * scale_x);
		-- result := x / scale - offset_x;
		result := (x - translate_x - offset_x) / scale;
		return result;
	end x_to_model;

	-- Translates from canvas y-coordinate to model coordinate:	
	function y_to_model (
		y : in gdouble)
		return gdouble
	is 
		result : gdouble;
	begin
		--result := -y - (offset_y * scale_y);
		-- result := -y / scale - offset_y;
		result := ( -(y - translate_y) - offset_y) / scale;
		return result;
	end y_to_model;


	
end geometry;

