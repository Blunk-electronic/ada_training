-- This is a simple ada program, that
-- demonstrates an access to a procedure type.

with ada.text_io;	use ada.text_io;

procedure access_procedures_1 is

	-- Define an access to ANY procedure that takes a string:
	type type_my_access is not null access procedure (s : in string);

	-- This is a simple procedure which takes a string:
	procedure say_hello ( text : in string ) is begin
		put_line(text);
	end say_hello;

	-- Instantiate an access of type type_my_access that refers to 
	-- procedure say_hello.
	p : type_my_access := say_hello'access;

begin
	-- Call procedure say_hello via access p:
	p("hello");
	
end access_procedures_1;
