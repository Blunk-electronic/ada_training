with Ada.Text_IO; use Ada.Text_IO;
with ada.command_line; use ada.command_line;
with ada.numerics.Generic_Elementary_Functions;

procedure threading_3 is
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

  task type CalcTask is
    entry CalcIsPrime (num : in positive);
  end CalcTask;

  task body CalcTask is
  begin
    loop 
      declare
        currentNum : positive;
      begin
        select
          accept CalcIsPrime(num : in positive) do
            currentNum := num;
          end CalcIsPrime;
          
          declare
	          prime : boolean := is_prime(currentNum);
	          endmessage : string := (if prime 
	                          then " is a prime number." 
	                          else " is not a prime number");
	        begin
		        put_line ( positive'image(currentNum) & endmessage );
		      end;

          or terminate;
        end select;
      end;
    end loop;
  end CalcTask;

  TaskPool : array (1..argument_count) of CalcTask;

begin
	for a in 1..argument_count loop
	  declare
	    num : positive := positive'value(argument(a));
	  begin
	    TaskPool(a).CalcIsPrime(num);
	  end;
	end loop;
end threading_3;
