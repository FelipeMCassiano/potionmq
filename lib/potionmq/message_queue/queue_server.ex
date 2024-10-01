defmodule Potionmq.MessageQueue.QueueServer do
  use GenServer

  def start_link(queue_name) do
    GenServer.start_link(__MODULE__, [], name: {:global, {:queue, queue_name}})
  end

  def add_message(queue_name, message) do
    GenServer.call({:global, {:queue, queue_name}}, {:add_message, message})
  end

  def fetch_message(queue_name) do
    GenServer.call({:global, {:queue, queue_name}}, :fetch_message)
  end

  # GenServer Callbacks
  @impl true
  def init(_) do
    {:ok, []}
  end

  @impl true
  def handle_call({:add_message, message}, _from, state) do
    {:reply, :ok, [message | state]}
  end

  @impl true
  def handle_call(:fetch_message, _from, [message | rest]) do
    {:reply, {:ok, message}, rest}
  end

  @impl true
  def handle_call(:fetch_message, _from, []) do
    {:reply, :empty, []}
  end
end
