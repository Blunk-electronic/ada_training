-- This simple ada program demonstrates simple 
-- arithmetic operations.

with ada.text_io;	use ada.text_io;
with interfaces;	use interfaces;

procedure operations_arithmetic_1 is

	byte : unsigned_8  := 2#00101101#; -- binary
 	word : unsigned_16 := 16#1020#; -- hexadecimal
	doubleword : unsigned_32 := 16#10203040#;

begin

	put_line ("byte : " & unsigned_8'image(byte));
	byte := byte or 2#10000000#; -- set bit 7
	byte := byte and 16#FE#; -- clear bit 0
	word := word * 4; -- shift left two bits

end operations_arithmetic_1;
