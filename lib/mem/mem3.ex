defmodule Mem940.Mem.Mem3 do
  @bits0 5
  @bits1 5
  @bits2 6
  @total_bits 16

  # estimate 80 ns to write and 20 ns to read

  def levels, do: {[@bits0, @bits1, @bits2], [2 ** @bits0, 2 ** @bits1, 2 ** @bits2]}

  def new() do
    count0 = 2 ** @bits0
    mem = Tuple.duplicate(0, count0)

    Enum.reduce(0..(count0 - 1), mem, fn index, mem ->
      part1 = new1()
      put_elem(mem, index, part1)
    end)
  end

  def write(mem, location, content) do
    {index0, index1, index2} = get_indices(location)
    orig1 = elem(mem, index0)
    new2 = elem(orig1, index1) |> put_elem(index2, content)
    new1 = put_elem(orig1, index1, new2)
    put_elem(mem, index0, new1)
  end

  def read(mem, location) do
    {index0, index1, index2} = get_indices(location)
    elem(mem, index0) |> elem(index1) |> elem(index2)
  end

  defp new1() do
    count1 = 2 ** @bits1
    mem = Tuple.duplicate(0, count1)

    Enum.reduce(0..(count1 - 1), mem, fn index, mem ->
      part2 = new2()
      put_elem(mem, index, part2)
    end)
  end

  defp new2(), do: Tuple.duplicate(:unset, 2 ** @bits2)

  def get_indices(location) do
    <<index0::size(@bits0), index1::size(@bits1), index2::size(@bits2)>> =
      <<location::@total_bits>>

    {index0, index1, index2}
  end
end
