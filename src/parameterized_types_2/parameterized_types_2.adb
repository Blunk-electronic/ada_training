-- Here we demonstrate a simple parameterized type
-- with a variant part.

with ada.text_io; use ada.text_io;
with ada.strings.unbounded; use ada.strings.unbounded;

procedure parameterized_types_2 is

	type type_car ( seat_count : positive) is
		record
			manufacturer : unbounded_string;
			door_count   : positive;
			case seat_count is
				when 1..8 => null;
				when others => special_driving_license : unbounded_string;
			end case;
					
		end record;

	c : type_car( seat_count => 4 );
begin
	c.manufacturer := to_unbounded_string("Vauxhall");
	
	-- c.special_driving_license := to_unbounded_string("class 1"); 
	-- causes a warning at compile time and constraint error at run time

end parameterized_types_2;
