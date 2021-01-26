
with ada.text_io;	use ada.text_io;

package body pac_1 is


	function p2 (object : type_A2) return type_enum is
	begin
		return LOW; -- still, the problem is not solved
	end p2;

	function p2 (object : type_B1) return type_enum is
	begin
		return HIGH; -- still, the problem is not solved
	end p2;

	
	procedure print_p2 (object : p2_interface'class) is
	begin
		put_line ("p2 = " & type_enum'image (object.p2));
	end print_p2; 

		
end pac_1;
