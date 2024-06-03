defmodule Mem940.Mem.Mem2 do
  @bits0 8
  @bits1 8
  @total_bits 16

  def levels, do: {[@bits0, @bits1], [2 ** @bits0, 2 ** @bits1]}

  def new() do
    count0 = 2 ** @bits0
    mem = Tuple.duplicate(0, count0)

    Enum.reduce(0..(count0 - 1), mem, fn index, mem ->
      part1 = new1()
      put_elem(mem, index, part1)
    end)
  end

  def write(mem, location, content) do
    {index0, index1} = get_indices(location)
    new_part = elem(mem, index0) |> put_elem(index1, content)
    put_elem(mem, index0, new_part)
  end

  def read(mem, location) do
    {index0, index1} = get_indices(location)
    elem(mem, index0) |> elem(index1)
  end

  defp new1(), do: Tuple.duplicate(:unset, 2 ** @bits1)

  def get_indices(location) do
    <<index0::size(@bits0), index1::size(@bits1)>> = <<location::@total_bits>>
    {index0, index1}
  end
end
