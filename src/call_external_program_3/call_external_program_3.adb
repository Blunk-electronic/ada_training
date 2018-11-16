-- This is a simple ada program, that demonstrates 
-- how to call an external program.

with ada.text_io;				use ada.text_io;
with gnat.os_lib;   			use gnat.os_lib;



procedure call_external_program_3 is
	result : natural;

	function system (cmd : string) return integer;
	pragma import (c, system);
begin
	result := system -- blocking
					(
					"/bin/sleep 2 && /bin/ls" & ASCII.NUL 
					);

	-- execution continues here after 
	-- program_name has finished.
	if result = 0 then
		put_line ("done");
	else
		put_line ("program execution failed");
	end if;

end call_external_program_3;
