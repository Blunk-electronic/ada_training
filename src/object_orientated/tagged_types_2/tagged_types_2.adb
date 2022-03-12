-- Here we demonstrate a simple tagged type.

with ada.text_io; use ada.text_io;
with ada.strings.unbounded; use ada.strings.unbounded;

procedure tagged_types_2 is

	type type_car is tagged
		record
			manufacturer : unbounded_string;
			door_count   : positive;
		end record;

	type type_car_with_special_licence (seat_count : positive)
		is new type_car with record
			special_licence : boolean := true;
	end record;
	
	c : type_car;
	d : type_car_with_special_licence (seat_count => 10);
begin
	c := type_car (d);
	d := (c with seat_count => 10, special_licence => false);
end tagged_types_2;
