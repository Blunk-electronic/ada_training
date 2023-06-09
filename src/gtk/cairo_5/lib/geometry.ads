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
		scale		: in gdouble)
		return type_point_canvas;


	type type_rectangle is record
		lower_left_corner : type_point_model := (0.0, 0.0);
		width : float := 400.0;
		height : float := 200.0;
	end record;
		
	
	scale_factor : gdouble := 1.0;

	
	function to_string (
		scale : in gdouble)
		return string;

	
	offset : constant type_point_canvas := (10.0, -1000.0);
											   
	translate_offset : type_point_canvas;


	scale_increment : constant gdouble := 2.0;
	
	procedure increase_scale;
	procedure decrease_scale;


	
end geometry;

