package vehicles is

	-- The root type of our vehicles is something
	-- that never exists in the real world. It is abstract:
	type type_vehicle is abstract tagged record
		seats : positive := 1; -- at least one seat
	end record;

	-- For all types derived from type_vehicle these
	-- primitive operations are available:
	function get_seats (
		v : in type_vehicle) 
		return positive;
	
	procedure set_seats (
		v : in out type_vehicle;
		s : in positive);
	


-- CAR:
	
	-- This type_car inherits the operations from type_vehicle:
	type type_car is new type_vehicle with record
		wheels : positive := 4;
	end record;

	-- Additional primitive operations for type_car:
	procedure make_default (
		c : in out type_car);
		
	procedure assemble (
		c : in out type_car;
		w : in positive;
		s : in positive);

	-- This function returns a class wide type
	-- and DOES NEVER get inherited by any derived types.
	-- As a consequence it can NOT be overridden.
	function make (
		s : in positive;
		w : in positive)
		return type_car'class;

	function get_wheels (
		c : in type_car) 
		return positive;

	procedure set_wheels (
		c : in out type_car;
		w : in positive);


					   
-- LORRY:
	
	-- This type_lorry inherits 
	-- - the operations from type_vehicle
	-- - the operations from type_car
	type type_lorry is new type_car with record
		loading_area : float := 0.0;
	end record;

	-- Additional primitive operations for type_lorry:
	function get_loading_area (
		l : in type_lorry) 
		return float;
	
	procedure set_loading_area (
		l : in out type_lorry;
		a : in float);


	-- The inherited make_default is not sufficient to make
	-- a standard lorry. For this reason we override the inherited
	-- make_default by a new one.
	-- The keyword "overriding" is an opional safeguard to indicate that we truly
	-- want to replace the inherited procedure.
	overriding procedure make_default (
	-- overriding procedure make_default ( -- does also work
		l : in out type_lorry);
	
	procedure assemble (
		l : in out type_lorry;
		w : in positive;
		s : in positive;
		a : in float);

	
	--overriding function make (
		--w : in positive; -- wheels
		--a : in float) -- loading area
		--return type_lorry;
								 
end vehicles;
