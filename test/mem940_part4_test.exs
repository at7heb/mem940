defmodule Mem9404Test do
  use ExUnit.Case
  doctest(Mem940)

  alias Mem940.Mem.Mem4

  test "Mem4 create" do
    {_, [size0, size1, size2, size3]} = Mem4.levels()
    mem = Mem4.new()
    assert is_tuple(mem)
    assert size0 == tuple_size(mem)
    part1 = elem(mem, 0)
    assert size1 == tuple_size(part1)
    part2 = elem(part1, 0)
    assert is_tuple(part2)
    assert size2 == tuple_size(part2)
    part3 = elem(part2, 0)
    assert is_tuple(part3)
    assert size3 == tuple_size(part3)
    word0 = elem(part3, 0)
    assert is_atom(word0)
    assert word0 == :unset
  end

  test "Mem4 set" do
    mem = Mem4.new()
    Enum.reduce(0..65535, mem, fn address, mem -> mem |> Mem4.write(address, 0) end)
  end

  test "Mem4 help" do
    {high, mid0, mid1, low} = Mem4.get_indices(1)
    assert high == 0 and mid0 == 0 and mid1 == 0 and low == 1
    {high, mid0, mid1, low} = Mem4.get_indices(65535)
    assert high == 15 and mid0 == 15 and mid1 == 15 and low == 15
    {high, mid0, mid1, low} = Mem4.get_indices(32767)
    assert high == 7 and mid0 == 15 and mid1 == 15 and low == 15
  end

  test "Mem4 set lots of times" do
    mem = Mem4.new()

    Enum.each(1..2000, fn _i ->
      Enum.reduce(0..65535, mem, fn address, mem ->
        mem |> Mem4.write(address, address - 32768)
      end)

      :unset
    end)
  end

  test "Mem4 write & verify" do
    mem = Mem4.new()
    mem = Enum.reduce(0..65535, mem, fn address, mem -> mem |> Mem4.write(address, address) end)

    indicators =
      Enum.map(0..65535, fn address -> Mem4.read(mem, address) == address end)

    assert Enum.all?(indicators)
  end

  test "Mem4 reads" do
    mem = Mem4.new()
    mem2 = Enum.reduce(0..65535, mem, fn address, mem -> mem |> Mem4.write(address, address) end)
    # Enum.each(1..100_000_000, fn _x -> Mem4.read(mem2, :rand.uniform(65535)) end)
    Enum.each(1..6, fn x -> Mem4.read(mem2, rem(x, 65536)) end)
    # Enum.each(1..100_000_000, fn _x -> :rand.uniform(65535) end)
  end
end
