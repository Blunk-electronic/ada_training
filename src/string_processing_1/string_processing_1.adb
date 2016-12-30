-- Here we demonstrate the limitations
-- of fixed strings.

with ada.text_io; use ada.text_io;

procedure string_processing_1 is
	a : string (1..3) := "Ada";
	b : string (1..4) := "2005";
	c : string (1..4) := "2012";
begin
	put_line (a & " " & b);
	put_line (a & " " & c);
	
	b := "2020";

	b := "95";  -- causes a compiler warning
				-- and constraint error at run time
end string_processing_1;
