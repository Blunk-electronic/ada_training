package body vehicles is

	function get_seats (
		v : in type_vehicle) 
		return positive 
	is begin
		return v.seats;
	end;
	
	procedure set_seats (
		v : in out type_vehicle;
		s : in positive)
	is begin
		v.seats := s;
	end set_seats;


	

-- CAR:
	
	procedure make_default (
		c : in out type_car)
	is begin
		c.seats := 3;
		c.wheels := 4;
	end make_default;
	
	procedure assemble (
		c : in out type_car;
		w : in positive;
		s : in positive)
	is begin
		c.seats := s;
		c.wheels := w;
	end assemble;

	
	function make (
		s : in positive;
		w : in positive)
		return type_car'class
	is 
		c : type_car := (s, w);

		-- A class type must be initialized immediately:
		result : type_car'class := c;
	begin
		return result;
	end make;

	
	function get_wheels (
		c : in type_car) 
		return positive 
	is begin
		return c.wheels;
	end;
	
	procedure set_wheels (
		c : in out type_car;
		w : in positive)
	is begin
		c.wheels := w;
	end set_wheels;


	
-- LORRY:
	
	function get_loading_area (
		l : in type_lorry) 
		return float 
	is begin
		return l.loading_area;
	end;

	procedure set_loading_area (
		l : in out type_lorry;
		a : in float)
	is begin
		l.loading_area := a;
	end;

	procedure make_default (
		l : in out type_lorry)
	is begin
		l.seats := 3;
		l.wheels := 4;
		l.loading_area := 7.89;
	end make_default;
	
	procedure assemble (
		l : in out type_lorry;
		w : in positive;
		s : in positive;
		a : in float)
	is begin
		l.seats := s;
		l.wheels := w;
		l.loading_area := a;
	end assemble;

	
	--overriding function make (
		--s : in positive; -- seats
		----w : in positive) -- wheels
		--w : in positive; -- wheels
		--a : in float) -- loading area
		--return type_lorry
	--is 
		----a : float := 10.4;
	--begin
		--return (seats => s, wheels => w, loading_area => a);
	--end make;
	
end vehicles;
