defmodule Mem9403Test do
  use ExUnit.Case
  doctest(Mem940)

  alias Mem940.Mem.Mem3

  test "Mem3 create" do
    {_, [size0, size1, size2]} = Mem3.levels()
    mem = Mem3.new()
    assert size0 == tuple_size(mem)
    part0 = elem(mem, 0)
    assert size1 == tuple_size(part0)
    part1 = elem(part0, 0)
    assert size2 == tuple_size(part1)
    word0 = elem(part1, 0)
    assert word0 == :unset
  end

  test "Mem3 set" do
    mem = Mem3.new()
    Enum.reduce(0..65535, mem, fn address, mem -> mem |> Mem3.write(address, 0) end)
  end

  test "Mem3 help" do
    {high, mid, low} = Mem3.get_indices(1)
    assert high == 0 and mid == 0 and low == 1
    {high, mid, low} = Mem3.get_indices(65535)
    assert high == 31 and mid == 31 and low == 63
    {high, mid, low} = Mem3.get_indices(32767)
    assert high == 15 and mid == 31 and low == 63
  end

  test "Mem3 set lots of times" do
    mem = Mem3.new()

    Enum.each(1..2, fn _i ->
      Enum.reduce(0..65535, mem, fn address, mem ->
        mem |> Mem3.write(address, address - 32768)
      end)

      :unset
    end)
  end

  test "Mem3 write & verify" do
    mem = Mem3.new()
    mem = Enum.reduce(0..65535, mem, fn address, mem -> mem |> Mem3.write(address, address) end)

    indicators =
      Enum.map(0..65535, fn address -> Mem3.read(mem, address) == address end)

    assert Enum.all?(indicators)
  end

  test "Mem3 reads" do
    mem = Mem3.new()
    mem2 = Enum.reduce(0..65535, mem, fn address, mem -> mem |> Mem3.write(address, address) end)
    # Enum.each(1..100_000_000, fn _x -> Mem3.read(mem2, :rand.uniform(65535)) end)
    Enum.each(1..6, fn x -> Mem3.read(mem2, rem(x, 65536)) end)
    # Enum.each(1..100_000_000, fn _x -> :rand.uniform(65535) end)
  end
end
