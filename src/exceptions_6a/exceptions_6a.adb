-- This is a simple ada program, that
-- demonstrates more comfortable  
-- exception handling.

with ada.text_io; use ada.text_io;
with ada.exceptions; use ada.exceptions;

procedure exceptions_6a is
	operator_error 	  : exception; -- user specific exception
	data_format_error : exception; -- user specific exception	
begin
	--raise operator_error with "Wrong key pressed !";
	--raise data_format_error with "Data format invalid !";	
	--raise constraint_error with "Index invald !";
	raise constraint_error; -- no message
	
	put_line("Everything fine."); -- skipped on exception

	-- Exception handler:
	exception
		when event:
			operator_error =>
				put_line(exception_information(event));
		when event:			
			data_format_error =>
				put_line(exception_information(event));
		when event:			
			constraint_error =>
				put_line(exception_information(event));	
		when others =>
			put_line ("Other error occured !");
			
end exceptions_6a;
