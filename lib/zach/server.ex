defmodule SayHi do
  use GenServer

  def init(args) do
    schedule_work()
    {:ok, args}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts.name)
  end

  def handle_cast({:hi, name_to_greet}, state) do
    IO.puts("Hi #{name_to_greet}, this is #{state.name}")

    {:noreply, state}
  end

  def handle_info(:health, state) do
    IO.puts("Hi, I'm alive and my name is #{state.name}")
    schedule_work()

    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :health, 1000)
  end
end
