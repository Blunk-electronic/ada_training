-------------------------------
--                           --
--      simple_library       --
--                           --
--         B o d y           --
-------------------------------

with ada.text_io; use ada.text_io;

package body simple_library is

	procedure output_text (text : in string) is
	begin
		put_line ( text );
	end output_text;

end simple_library;