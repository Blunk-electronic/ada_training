with Ada.Text_IO; use Ada.Text_IO;

procedure threading_1 is
  task type Buffer_Task is
    entry Insert (Item : in Integer);
    entry Remove (Item : out Integer);
  end Buffer_Task;

  Buffer_Pool : array (1..15) of Buffer_Task;
  This_Item : Integer;

  task body Buffer_Task is
    Datum : Integer;
  begin
    loop 
      select
        accept Insert(Item : in Integer) do
          Datum := Item;
        end Insert;
      or
        terminate;
      end select;
      select
        accept Remove(Item : out Integer) do
          Item := Datum;
        end Remove;
      or
        terminate;
      end select;
    end loop;
  end Buffer_Task;
begin
  Buffer_Pool(1).Insert(5);
  Buffer_Pool(1).Remove(This_Item);
  Put_Line(This_Item'Image);
end threading_1;
