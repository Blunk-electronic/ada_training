-- This is a simple ada program, that
-- demonstrates more comfortable  
-- exception handling.

with ada.text_io; use ada.text_io;
with ada.exceptions; use ada.exceptions;

procedure exceptions_6 is
	operator_error 	  : exception; -- user specific exception
begin
	raise operator_error with "Wrong key pressed !";
	--raise constraint_error;
	
	put_line("Everything fine."); -- skipped on exception

	-- Exception handler:
	exception
		when event:
			operator_error =>
				put_line(exception_information(event));
		when constraint_error =>
			put_line ("Constraint error occured !");
		when others =>
			put_line ("Other error occured !");
			
end exceptions_6;
