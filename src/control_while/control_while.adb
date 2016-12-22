-- This is a simple ada program, that counts with
-- a "while"-loop.

with ada.text_io; use ada.text_io;

procedure control_while is

	number : integer := 1;

begin

	while number <= 16 loop
		put_line ("step:" & integer'image(number));
		number := number * 2;
	end loop;

end control_while;
