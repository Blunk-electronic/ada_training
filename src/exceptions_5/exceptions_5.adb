-- This is a simple ada program, that
-- demonstrates an advanced exception 
-- handler.

with ada.text_io; use ada.text_io;

procedure exceptions_5 is
	operator_error 	  : exception; -- user specific exception
	program_position  : natural := 0;
begin
	--raise operator_error;
	
	program_position := 10;
	--raise operator_error;
	
	program_position := 30;	raise operator_error;
	
	put_line("Everything fine."); -- skipped on exception

	-- Exception handler:
	exception
		when constraint_error =>
			put_line ("Constraint error occured !");
		when operator_error =>
			put ("Operator error ! ");
			case program_position is
				when  0 => put_line("Missing arguments");
				when 10 => put_line("Invalid argument given.");
				when others => put_line("Contact administrator !");
			end case;
		when others =>
			put_line ("Other error occured !");
			
end exceptions_5;
