-- This is a simple ada program, that outputs "hello world !" at the terminal.

-- build with command "gprbuild gprbuild_hello"
-- clean up with command "gprclean"

with ada.text_io;	

procedure gprbuild_hello is

begin

	ada.text_io.put_line ("hello world !");

end gprbuild_hello;
