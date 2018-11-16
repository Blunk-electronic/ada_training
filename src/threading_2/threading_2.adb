with Ada.Text_IO; use Ada.Text_IO;
with ada.command_line; use ada.command_line;
with ada.numerics.Generic_Elementary_Functions;

procedure threading_2 is
  type myfloat is digits 10 range 1.0 .. float(positive'last);
  package math is new ada.numerics.Generic_Elementary_Functions(myfloat);

  function is_prime(input : positive) return boolean is
    root : myfloat := math.sqrt(myfloat(input));
    below_root : natural := natural(myfloat'floor(root));
  begin
    for i in 2..below_root loop
      delay 0.5; -- make the calculation slow enough
      if input mod i = 0 then
        return false;
      end if;
    end loop;
    return true;
  end is_prime;
begin

  -- try e.g. ./threading_2 31 31
  -- it will take approx. 8 seconds, waiting for each of the calculations
  -- modify this example so that it will launch the calculations in parallel 
  -- and therefore be twice as fast

	for a in 1..argument_count loop
	  declare
	    num : positive := positive'value(argument(a));
	    prime : boolean := is_prime(num);
	    endmessage : string := (if prime 
	                    then " is a prime number." 
	                    else " is not a prime number");
	  begin
		  put_line ( argument(a) & endmessage );
		end;
	end loop;
end threading_2;
