-- This is a simple ada program, that counts with
-- a "for"-loop.

with ada.text_io; use ada.text_io;

procedure control_for is

begin
	for number in 1..4 loop
		put_line ("step:" & integer'image(number));
	end loop;

end control_for;
