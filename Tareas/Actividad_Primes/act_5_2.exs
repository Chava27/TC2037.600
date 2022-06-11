#Program that returns prime number depending
#
# Salvador Salgado Normandia
# Luis Javier Karam Galland

defmodule Hw.Primes do

  def prime(limit) when limit == 1, do: 0
  def prime(limit) when limit == 2, do: 2
  def prime(limit), do: do_prime(limit,ceil(:math.sqrt(limit)),2)
  defp do_prime(limit,stop,count) when count==stop + 1, do: limit
  defp do_prime(limit,stop,count) do
    cond do
      rem(limit,count) === 0 -> do_prime(limit)
      true -> do_prime(limit,stop,count+1)
    end
  end
  defp do_prime(_limit), do: 0

  def sum_primes(limit), do: sum_primes(0,limit)
  def sum_primes(start, limit) do
  start..limit
  |> Enum.map(&prime(&1))
  |> IO.inspect
  |> Enum.sum()
  end
  def sum_primes_parallel(limit) do
    threads = System.schedulers()
    cond do
      threads > limit -> sum_primes_parallel(limit, limit)
      true ->     sum_primes_parallel(limit, threads)
    end
  end

  def sum_primes_parallel(limit,threads) do
    range = div(limit, threads)
    residue = limit - range * threads
    ranges = Enum.map(1..threads, fn x -> x*range end)
    last_element = List.last(ranges)

    result = ranges
    |> Enum.map(&Task.async(fn -> sum_primes(&1 - range + 1, &1) end))
    |> Enum.map(&Task.await/1)
    |> Enum.sum()
    if residue != 0 do
    result + sum_primes(last_element, last_element + residue)
    else
      result
    end
  end

  def meassure_time(function) do
    function
    |> :timer.tc()
    |> elem(0)
    |> Kernel./(1_000_000)
    |> IO.inspect()
  end

  def main do
    meassure_time(fn -> Hw.Primes.sum_primes_parallel(10000000) end)
  end

  end
