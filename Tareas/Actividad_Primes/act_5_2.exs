#Program that returns prime number depending
#
# Salvador Salgado Normandia
# Luis Javier Karam Galland

defmodule Hw.Primes do

  def prime(limit) when limit == 1, do: nil
  def prime(limit) when limit == 2, do: 2
  def prime(limit), do: do_prime(floor(:math.sqrt(limit)),1)
  defp do_prime(limit,count) when count==limit, do: limit
  defp do_prime(limit,count) do
    cond do
      IO.puts "entrando al comparador"
      rem(limit,count) === 0 -> do_prime(limit)
      true -> do_prime(limit,count+1)
    end
  end
  defp do_prime(_limit), do: 0

  def sum_primes(limit) do
  limit =  floor(:math.sqrt(limit))
  1..limit
  |> Enum.map(&prime(&1))
  |> Enum.join()
  end

  def sum_primes_parallel(limit) do
    threads = System.schedulers()
    sum_primes_parallel(limit, threads)
  end
  def sum_primes_parallel(limit,threads) do
    IO.puts "MAIN THREAD END"


    IO.puts "MAIN THREAD START"
  end

end
