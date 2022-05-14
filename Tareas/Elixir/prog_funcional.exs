#Programacion Funcional PT.2
#Luis Javier Karam Galland - A01751941
#Salvador Salgado Normandia

import Kernel

defmodule M do
  @moduledoc """
  Functions manipulating lists in elixir
  """


  @doc """
  Function main used to call all the other functions on runtime
  """
  def main do
    list1 = [1,2,3,5,7]
    IO.inspect list1, charlists: :as_lists
    IO.inspect insert(0,list1), charlists: :as_lists

    list2 = [9,3,4,2,1,6]
    IO.inspect list2, charlists: :as_lists
    IO.inspect insert_sort(list2)

    list3 = ["a","b","c","d","e","f","g"]

    rotate_left(-3, list3)

    list4 = ["a","a","b","c","c","c","d"]
    encode(list4)

  end


@doc """
  insert element at the end of a list
  """
  def insert(x, [head | tail]) when x < head, do: [x] ++ [head] ++ tail
  def insert(x,list) when list == [], do: list ++ [x]
  def insert(x,[head | tail]) when x == 0, do: [x] ++ [head] ++ tail
  def insert(x,[head | tail]) do
    if x >= head and x <= Enum.at(tail,0) do
      [head] ++ [x] ++ tail
    else
      do_insert(x, tail, [head])
    end
  end
  defp do_insert(x, [head | tail], temp) do
    if x >= head and x <= Enum.at(tail,0) do
      temp ++ [head] ++ [x] ++ tail
    else
      do_insert(x, tail, temp ++ [head])
    end
  end

  @doc """
  takes unsorted list and returns a sorted version of the list (bubble sort)
  """
  def insert_sort(list) do
    t = do_insert_sort(list)
    if t == list, do: t, else: insert_sort(t)
  end
    defp do_insert_sort([x, y | t]) when x > y, do: [y | do_insert_sort([x | t])]
    defp do_insert_sort([x, y | t]), do: [x | do_insert_sort([y | t])]
    defp do_insert_sort(list), do: list


  @doc """
  rotates to the left and returns the list, so (1,2,3,4,5) and 1 would result (2,3,4,5,1)
  """
  def rotate_left(list,x) when x<0, do: rotate_right(Enum.reverse(list), Kernel.abs(x))
  def rotate_left([],x), do: []
  def rotate_left([head | tail], x) when x==1, do: tail ++ [head]
  def rotate_left([head | tail], x), do: rotate_left(tail ++ [head], x - 1)
  defp rotate_right([head | tail], x) when x==1, do: Enum.reverse(tail ++ [head])
  defp rotate_right([head | tail], x) when x==1, do: Enum.reverse(tail ++ [head])
  defp rotate_right([head | tail], x), do: rotate_right(tail ++ [head], x - 1)


  @doc """
  encode function that takes a list and returns a list of pairs of ocurrences, so (1,1,2,2,3) would result in ((2,1),(2,2),(1,3))
  """
  def encode(list), do: do_encode(list,[], 1)
  defp do_encode([], result), do: Enum.reverse(result)
  defp do_encode([],result, count), do: result
  defp do_encode([x|y], result, count) when y==[], do: do_encode([], [[count,x]|result])
  defp do_encode([x,y|t], result, count) when x==y, do: do_encode([y|t], result, count+1)
  defp do_encode([x,y|t], result, count), do: do_encode([y|t],[[count,x]|result], 1)
end
