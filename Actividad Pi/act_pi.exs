#Using parallelism to accelerate calculations using threads
#
#Salvador Salgado Normandia

defmodule PiSolve do
  def pi_term(n), do: -1**(n+1) * 4 / (2*n-1)
  def get_pi_seq(0), do: 0
  def get_pi_seq(limit), do: do_get_pi(1, limit, 0)

  defp do_get_pi(start, finish, res) when start > finish, do: res
  defp do_get_pi(start,finish, rers),
    do: do_get_pi(start+1, finish, res+pi_term(start))

  def get_pi_par(limit, threads) do
    range = div(limit,threads)

  end
  

end
