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

	model_origin : constant type_point_model := (0.0, 0.0);
	

	function to_string (
		distance : in type_distance_model)
		return string;

	
	function to_string (
		point	: in type_point_model)
		return string;


	
	function invert (
		point	: in type_point_model)
		return type_point_model;
	
						 
	-- Moves a model point by the given offset:
	procedure move_by (
		point	: in out type_point_model;
		offset	: in type_point_model);


	type type_bounding_box is record
		width		: type_distance_model;
		height		: type_distance_model;
		position	: type_point_model; -- lower left corner
	end record;

	-- This is the bounding-box of the model. It is a rectangle
	-- that encloses all objects of the model and the margins 
	-- around the model:
	bounding_box : type_bounding_box;

	
	function to_string (
		box : in type_bounding_box)
		return string;
	
	
	-- The margin around the drawing is part of the model.
	-- The bounding box includes the margin:
	margin : constant type_distance_model := 5.0;
	
	margin_offset : constant type_point_model := (
		x	=> margin,
		y	=> margin);

	
	-- Detects the smallest and greatest x and y values used by the model.
	-- Sets the global variable bounding_box:
	procedure compute_bounding_box;


	
-- CANVAS:

	subtype type_distance_canvas is gdouble range 0.0 .. gdouble'last;
	
	type type_point_canvas is record
		x, y : gdouble := 0.0;
	end record;

		
	function to_string (
		point	: in type_point_canvas)
		return string;


	

	
	

	
	-- The place on the canvase where the model 
	-- coordinates system has its origin:
	base_offset : type_point_canvas;
		

	procedure compute_base_offset;

	-- The offset by which all draw operations on the canvas
	-- are translated when the operator zooms to the mouse pointer:
	translate_offset : type_point_canvas := (0.0, 0.0);


	

-- CONVERSION BETWEEN MODEL AND CANVAS:

	function to_model (
		point	: in type_point_canvas;
		scale	: in type_scale_factor;
		real 	: in boolean := false) -- if real model coordinates are required
		return type_point_model;
	

	function to_canvas (
		point 	: in type_point_model;
		scale	: in type_scale_factor;
		real	: in boolean := false) -- if real model coordinates are given
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

