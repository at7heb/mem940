defmodule Mem940Test do
  use ExUnit.Case
  doctest(Mem940)

  alias Mem940.Mem.Mem2

  test "mem2 create" do
    {_, [size0, size1]} = Mem2.levels()
    mem = Mem2.new()
    assert size0 == tuple_size(mem)
    part0 = elem(mem, 0)
    assert size1 == tuple_size(part0)
    word0 = elem(part0, 0)
    assert word0 == :unset
  end

  test "mem2 set" do
    mem = Mem2.new()
    Enum.reduce(0..65535, mem, fn address, mem -> mem |> Mem2.write(address, 0) end)
  end

  test "mem2 help" do
    {high, low} = Mem2.get_indices(1)
    assert high == 0 and low == 1
    {high, low} = Mem2.get_indices(65535)
    assert high == 255 and low == 255
    {high, low} = Mem2.get_indices(32767)
    assert high == 127 and low == 255
  end

  test "mem2 set lots of times" do
    mem = Mem2.new()

    Enum.each(1..10, fn _i ->
      Enum.reduce(0..65535, mem, fn address, mem -> mem |> Mem2.write(address, 0) end)
      :unset
    end)
  end

  test "mem2 write & verify" do
    mem = Mem2.new()
    mem = Enum.reduce(0..65535, mem, fn address, mem -> mem |> Mem2.write(address, address) end)

    indicators =
      Enum.map(0..65535, fn address -> Mem2.read(mem, address) == address end)

    assert Enum.all?(indicators)
  end
end
