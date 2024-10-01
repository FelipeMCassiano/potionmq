defmodule Potionmq.MessageQueue.QueueSupervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    children = [
      {Potionmq.MessageQueue.QueueServer, ["default_queue"]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
