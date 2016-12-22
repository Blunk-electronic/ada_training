-- This is a simple ada program, that counts with
-- a "for"-loop and outputs certain numbers.

with ada.text_io; use ada.text_io;

procedure control_case is

begin
	for n in 1..6 loop
		case n is
			when 2 =>
				put_line ("step:" & integer'image(n));
			when 5 =>
				put_line ("step:" & integer'image(n));
			when others => -- required
				null;
		end case;
	end loop;

end control_case;
