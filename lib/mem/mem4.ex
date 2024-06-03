defmodule Mem940.Mem.Mem4 do
  @bits0 4
  @bits1 4
  @bits2 4
  @bits3 4
  @total_bits 16

  # estimate 80 ns to write and 20 ns to read

  def levels,
    do: {[@bits0, @bits1, @bits2, @bits3], [2 ** @bits0, 2 ** @bits1, 2 ** @bits2, 2 ** @bits3]}

  def new() do
    count0 = 2 ** @bits0
    mem = Tuple.duplicate(0, count0)

    Enum.reduce(0..(count0 - 1), mem, fn index, mem ->
      part1 = new1()
      put_elem(mem, index, part1)
    end)
  end

  def write(mem, location, content) do
    {index0, index1, index2, index3} = get_indices(location)
    orig1 = elem(mem, index0)
    orig2 = elem(orig1, index1)
    orig3 = elem(orig2, index2)
    new3 = put_elem(orig3, index3, content)
    new2 = put_elem(orig2, index2, new3)
    new1 = put_elem(orig1, index1, new2)
    put_elem(mem, index0, new1)
  end

  def read(mem, location) do
    {index0, index1, index2, index3} = get_indices(location)
    elem(mem, index0) |> elem(index1) |> elem(index2) |> elem(index3)
  end

  defp new1() do
    count1 = 2 ** @bits1
    mem = Tuple.duplicate(0, count1)

    Enum.reduce(0..(count1 - 1), mem, fn index, mem ->
      part2 = new2()
      put_elem(mem, index, part2)
    end)
  end

  defp new2() do
    count2 = 2 ** @bits2
    mem = Tuple.duplicate(0, count2)

    Enum.reduce(0..(count2 - 1), mem, fn index, mem ->
      part3 = new3()
      put_elem(mem, index, part3)
    end)
  end

  defp new3(), do: Tuple.duplicate(:unset, 2 ** @bits3)

  def get_indices(location) do
    <<index0::size(@bits0), index1::size(@bits1), index2::size(@bits2), index3::size(@bits3)>> =
      <<location::@total_bits>>

    {index0, index1, index2, index3}
  end
end
