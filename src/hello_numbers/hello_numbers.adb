-- This is a simple ada program, that outputs "hello Ada 2005"
-- and "hello Ada 2012" on the terminal.

with ada.text_io;	
use ada.text_io;

procedure hello_numbers is

	number_1 : integer := 2005;
	string_1 : string (1..9) := "hello Ada";

begin
	put_line (string_1 & integer'image(number_1));
	number_1 := number_1 + 7;
	put_line (string_1 & integer'image(number_1));
end hello_numbers;
