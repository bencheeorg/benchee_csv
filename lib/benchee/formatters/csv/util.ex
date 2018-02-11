defmodule Benchee.Formatters.CSV.Util do
  @moduledoc false

  @doc """
  Contrary to `List.zip/1` zips all elements of the list together and doesn't
  stop as soon as one of the lists doesn't have any elements anymore.

  Missing elements are filled up with `nil`.


  ## Examples

      iex> Benchee.Formatters.CSV.Util.zip_all([[1, 2], [3, 4], [5, 6]])
      [[1, 3, 5], [2, 4, 6]]

      iex> Benchee.Formatters.CSV.Util.zip_all([[1, 2, 3], [3, 4], [5, 6]])
      [[1, 3, 5], [2, 4, 6], [3, nil, nil]]

      iex> Benchee.Formatters.CSV.Util.zip_all([[1, 2, 3], [3, 4], [5, 6, 7, 8]])
      [[1, 3, 5], [2, 4, 6], [3, nil, 7], [nil, nil, 8]]

      iex> Benchee.Formatters.CSV.Util.zip_all([[], [], []])
      []

      iex> Benchee.Formatters.CSV.Util.zip_all([[], [], [4], []])
      [[nil, nil, 4, nil]]

      iex> Benchee.Formatters.CSV.Util.zip_all([])
      []

      iex> Benchee.Formatters.CSV.Util.zip_all([[]])
      []

      iex> Benchee.Formatters.CSV.Util.zip_all([[3, 2]])
      [[3], [2]]
  """
  def zip_all(list_of_lists) do
    do_zip(list_of_lists, [])
  end

  defp do_zip(list_of_lists, acc) do
    converter = fn list, acc -> do_zip_each(list, acc) end
    {remaining, heads} = Enum.map_reduce(list_of_lists, [], converter)
    do_zip_recur(remaining, heads, acc)
  end

  defp do_zip_each([], acc), do: {[], [nil | acc]}
  defp do_zip_each([head | tail], acc), do: {tail, [head | acc]}

  defp do_zip_recur(remaining, heads, acc) do
    if Enum.all?(heads, &is_nil/1) do
      Enum.reverse(acc)
    else
      do_zip(remaining, [Enum.reverse(heads) | acc])
    end
  end
end
