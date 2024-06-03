alias Mem940.Mem.Mem2
alias Mem940.Mem.Mem3
alias Mem940.Mem.Mem4

mem2 = Mem2.new()
mem3 = Mem3.new()
mem4 = Mem4.new()

Benchee.run(
  %{
    "mem4 writes address" => fn ->
      Enum.reduce(0..65535, mem4, fn address, mem ->
        mem |> Mem4.write(address, address)
      end)
    end,
    "mem4 writes zero" => fn ->
      Enum.reduce(0..65535, mem4, fn address, mem ->
        mem |> Mem4.write(address, 0)
      end)
    end,
    "mem4 writes arith" => fn ->
      Enum.reduce(0..65535, mem4, fn address, mem ->
        mem |> Mem4.write(address, 32768 - address)
      end)
    end,
    "mem4 each writes zero" => fn ->
      Enum.each(0..65535, fn address ->
        mem4 |> Mem4.write(address, 0)
      end)
    end,

    # mem3
    "mem3 writes address" => fn ->
      Enum.reduce(0..65535, mem3, fn address, mem ->
        mem |> Mem3.write(address, address)
      end)
    end,
    "mem3 writes zero" => fn ->
      Enum.reduce(0..65535, mem3, fn address, mem ->
        mem |> Mem3.write(address, 0)
      end)
    end,
    "mem3 writes arith" => fn ->
      Enum.reduce(0..65535, mem3, fn address, mem ->
        mem |> Mem3.write(address, 32768 - address)
      end)
    end,

    # mem2
    "mem2 writes address" => fn ->
      Enum.reduce(0..65535, mem2, fn address, mem ->
        mem |> Mem2.write(address, address)
      end)
    end,
    "mem2 writes zero" => fn ->
      Enum.reduce(0..65535, mem2, fn address, mem ->
        mem |> Mem2.write(address, 0)
      end)
    end,
    "mem2 writes arith" => fn ->
      Enum.reduce(0..65535, mem2, fn address, mem ->
        mem |> Mem2.write(address, 32768 - address)
      end)
    end
  },
  parallel: 4
)
