-- This is a simple ada program, that outputs "hello world !" at the terminal.

with ada.text_io;	
--use ada.text_io;

procedure hello is

begin
	ada.text_io.put_line ("hello world !");
end hello;
