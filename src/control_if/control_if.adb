-- This is a simple ada program, that counts with
-- a "for"-loop and outputs even numbers.

with ada.text_io; use ada.text_io;

procedure control_if is

begin
	for number in 1..6 loop
		if (number rem 2) = 0 then
			put_line ("step:" & integer'image(number));
		end if;
	end loop;

end control_if;
