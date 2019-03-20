defmodule ZachTest do
  use ExUnit.Case

  test "greets the world" do
    {:ok, zach} = SayHi.start_link(%{name: :zach})
    {:ok, paulo} = SayHi.start_link(%{name: :paulo})

    :ok = :pg2.create(:elixir_devs)
    :ok = :pg2.join(:elixir_devs, zach)
    :ok = :pg2.join(:elixir_devs, paulo)

    :pg2.get_members(:elixir_devs)
    |> Enum.each(fn member ->
      GenServer.cast(member, {:hi, "Penny"})
      GenServer.cast(member, {:hi, "Silvia"})
    end)

    require IEx; IEx.pry
  end
end
