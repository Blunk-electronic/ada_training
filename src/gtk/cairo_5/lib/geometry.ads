with glib;						use glib;

package geometry is



-- SCALE:

	type type_scale_factor is digits 4 range 0.1 .. 10.0;
	scale_factor : type_scale_factor := 1.0;
	scale_increment : constant type_scale_factor := 1.2;


	function to_string (
		scale : in type_scale_factor)
		return string;
	
	procedure increase_scale;
	procedure decrease_scale;

	

-- MODEL:
	
	type type_distance_model is delta 0.01 digits 8 range -100_000.00 .. 100_000.00;
	
	type type_point_model is record
		x, y : type_distance_model := 0.0;
	end record;


	function to_string (
		point	: in type_point_model)
		return string;



-- CANVAS:

	subtype type_distance_canvas is gdouble range 0.0 .. gdouble'last;
	
	type type_point_canvas is record
		x, y : gdouble := 0.0;
	end record;

		
	function to_string (
		point	: in type_point_canvas)
		return string;


	type type_bounding_box is record
		width	: type_distance_model;
		height	: type_distance_model;
	end record;

	-- This is the bounding-box of the model. It is a rectange
	-- that encloses all objects of the model:
	bounding_box : type_bounding_box;
	

	-- Detects the smalles and greatest x and y values used by the model.
	-- Sets the global variable bounding_box:
	procedure compute_bounding_box;
	
	
	-- margin : constant gdouble := 10.0;
	-- canvas_default_width  : constant gdouble := gdouble (bounding_box_width)  + margin;
	-- canvas_default_height : constant gdouble := gdouble (bounding_box_height) + margin;

	
	-- The place on the canvase where the model 
	-- coordinates system has its origin:
	base_offset_default : constant type_point_canvas := (
		x => 10.0, 
		--y => -500.0 - gdouble (bounding_box_height / 2.0));
		y => -2000.0);
		
	-- base_offset_default : constant type_point_canvas := (
	-- 	x => margin * 0.5,
	-- 	y => -2.0 * (gdouble (bounding_box_height) - margin * 0.5));
	
	-- base_offset_default : constant type_point_canvas := (0.0, - canvas_default_height);
	base_offset : type_point_canvas := base_offset_default;
	

	-- The offset by which all draw operations on the canvas
	-- are translated when the operator zooms to the mouse pointer:
	translate_offset : type_point_canvas := (0.0, 0.0);


	

-- CONVERSION BETWEEN MODEL AND CANVAS:

	function to_model (
		point		: in type_point_canvas;
		scale		: in type_scale_factor;
		translate	: in type_point_canvas;
		offset		: in type_point_canvas)
		return type_point_model;
	

	function to_canvas (
		point 		: in type_point_model;
		scale		: in type_scale_factor;
		offset		: in type_point_canvas)
		return type_point_canvas;



		
-- DUMMY OBJECT TO BE DRAWN ON THE CANVAS:

	type type_rectangle is record
		lower_left_corner : type_point_model;
		width  : type_distance_model := bounding_box.width;
		height : type_distance_model := bounding_box.height;
	end record;
	

	object : type_rectangle;

	procedure make_object;
	
end geometry;

