defmodule Zach.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # {Zach.Worker, arg},
    ]

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

    opts = [strategy: :one_for_one, name: Zach.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
