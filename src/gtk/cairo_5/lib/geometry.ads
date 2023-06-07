with glib;						use glib;

package geometry is

	type type_point_model is record
		x, y : float := 0.0; -- CS use a fixed point type
	end record;


	function to_string (
		point	: in type_point_model)
		return string;


	type type_point_canvas is record
		x, y : gdouble := 0.0;
	end record;

		
	function to_string (
		point	: in type_point_canvas)
		return string;


	function to_model (
		point		: in type_point_canvas;
		scale		: in gdouble;
		translate	: in type_point_canvas)
		return type_point_model;
	

	function to_canvas (
		point 		: in type_point_model;
		scale		: in gdouble;
		translate	: in type_point_canvas)
		return type_point_canvas;

	
	
	scale : gdouble := 1.0;
	scale_old : gdouble := 1.0;
	
	offset_x : constant gdouble :=    10.0;
	offset_y : constant gdouble := -1000.0;
	offset : constant type_point_canvas := (10.0, -1000.0);
											   
	zoom_center_x_m : gdouble := 0.0;
	zoom_center_y_m : gdouble := 0.0;

	zoom_center_x_c : gdouble := 0.0;
	zoom_center_y_c : gdouble := 0.0;

	translate_x : gdouble := 0.0;
	translate_y : gdouble := 0.0;
	translate_offset : type_point_canvas;

	procedure increase_scale;
	procedure decrease_scale;


	-- Translates from model x-coordinate to canvas coordinate:	
	function x_to_canvas (
		x : in gdouble)
		return gdouble;

	
	-- Translates from model y-coordinate to canvas coordinate:	
	function y_to_canvas (
		y : in gdouble)
		return gdouble;
	


	-- Translates from canvas x-coordinate to model coordinate:
	function x_to_model (
		x : in gdouble)
		return gdouble;
	

	-- Translates from canvas y-coordinate to model coordinate:	
	function y_to_model (
		y : in gdouble)
		return gdouble;

	
end geometry;

