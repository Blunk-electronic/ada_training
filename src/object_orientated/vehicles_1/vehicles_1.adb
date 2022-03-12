-- This simple ada program demonstrates type extension
-- and inheritance of primitive operations:

with ada.text_io; 	use ada.text_io;
with vehicles;		use vehicles; 		

procedure vehicles_1 is

	--seats : positive;
	wheels : positive;
	area : float;

	-- Just a vehicle can not be declared because type_vehicle is abstract:
	-- vehicle : type_vehicle; -- does not complile
	
	car : type_car;
	lorry : type_lorry;
	
begin
	
-- CAR:
	car.make_default;
	car.assemble (s => 3, w => 4);
	car.set_wheels (4);
	wheels := car.get_wheels;

	car := type_car (make (s => 3, w => 4));

-- LORRY:
	lorry.make_default;
	put_line (float'image (lorry.loading_area));
	
	-- The procedure "assemble" was inherited from type_car but 
	-- it is not sufficient to assemble a car:
	lorry.assemble (s => 3, w => 8); 
	
	-- There is a dedicated procedure "assemble" for type_lorry:
	lorry.assemble (s => 3, w => 8, a => 4.5);
	
	lorry.set_wheels (6); -- set_wheels inherited from type_car
	wheels := lorry.get_wheels; -- get_wheels also inherited from type_car

	lorry.set_loading_area (10.0);
	area := lorry.get_loading_area;

	-- These statements do not compile because
	-- for type_car there is no loading area:
	
	-- car.set_loading_area (5.5);
	-- area := car.get_loading_area;


	-- advanced bonus stuff:
	
	-- lorry := type_lorry (make (s => 3, w => 4));
	-- raised CONSTRAINT_ERROR : vehicles_1.adb:47 tag check failed

	lorry := (type_car (make (s => 3, w => 4)) with loading_area => 3.3);
	
end vehicles_1;
