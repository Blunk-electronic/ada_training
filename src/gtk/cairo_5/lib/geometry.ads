with glib;						use glib;

package geometry is



-- SCALE:
	
	type type_scale_factor is digits 4 range 0.1 .. 100.0;
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



	-- canvas_default_width  : constant gdouble := 800.0;
	-- canvas_default_height : constant gdouble := 400.0;
	bounding_box_width  : constant type_distance_model := 400.0;
	bounding_box_height : constant type_distance_model := 200.0;
	
	margin : constant gdouble := 10.0;
	canvas_default_width  : constant gdouble := gdouble (bounding_box_width)  + margin;
	canvas_default_height : constant gdouble := gdouble (bounding_box_height) + margin;

	
	-- The place on the canvase where the model 
	-- coordinates system has its origin:
	--base_offset : type_point_canvas := (0.0, -200.0);
	base_offset_default : constant type_point_canvas := (
		margin * 0.5,
		- gdouble (bounding_box_height) - margin * 0.5);
	
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



		
-- DUMMY OBJECTS TO BE DRAWN ON THE CANVAS:

	type type_rectangle is record
		lower_left_corner : type_point_model := (0.0, 0.0);
		width  : type_distance_model := bounding_box_width;
		height : type_distance_model := bounding_box_height;
	end record;
	

	object : type_rectangle;

	top_right : constant type_point_model := (bounding_box_width, bounding_box_height);

	
end geometry;

