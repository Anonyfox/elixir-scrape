defmodule Util do
  
  def first_element(list) do 
    list 
    |> List.wrap
    |> List.first
  end

end