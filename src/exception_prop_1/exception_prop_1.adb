-- This is a simple ada program, that
-- demonstrates how exceptions propagate
-- from a procedure to the mainline program.

with ada.text_io; use ada.text_io;

procedure exception_prop_1 is
	operator_error 	  : exception; -- user specific exception

	procedure request_operator_input is
	begin
		null; -- assume operator input here
		raise operator_error; -- we intentionally raise an exception
	end request_operator_input;
	
begin
	request_operator_input;
	
	put_line("Everything fine."); -- skipped on exception

	-- Exception handler:
	exception
		when operator_error =>
			put_line ("Operator error occured !");
		when others =>
			put_line ("Other error occured !");
			
end exception_prop_1;
