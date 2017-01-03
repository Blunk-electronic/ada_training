-- This is a simple ada program, that
-- demonstrates a moderate exception 
-- handler.

with ada.text_io; use ada.text_io;

procedure exceptions_4 is
	data_format_error : exception; -- user specific exception
	operator_error 	  : exception; -- user specific exception	
begin
	-- We intentionally raise exceptions to demonstrate the
	-- exception handler:
	
	-- raise constraint_error;
	-- raise storage_error;
	-- raise data_format_error;
	raise operator_error;
	
	put_line("Everything fine."); -- skipped on exception

	-- Exception handler:
	exception
		when constraint_error =>
			put_line ("Constraint error occured !");
		when storage_error =>
			put_line ("Storage error occured !");
		when data_format_error =>
			put_line ("Data format error occured !");
		when others =>
			put_line ("Other error occured !");
			
end exceptions_4;
