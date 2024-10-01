defmodule PotionmqWeb.MessageChannel do
  use Phoenix.Channel

  def join("queue:" <> queue_name, _payload, socket) do
    {:ok, assign(socket, :queue_name, queue_name)}
  end

  def handle_in("new_message", %{"message" => message}, socket) do
    queue_name = socket.assigns[:queue_name]

    Potionmq.MessageQueue.QueueServer.add_message(queue_name, message)
    broadcast(socket, "message_added", %{message: message})
    {:noreply, socket}
  end

  def handle_in("fetch_message", _payload, socket) do
    queue_name = socket.assigns[:queue_name]

    case Potionmq.MessageQueue.QueueServer.fetch_message(queue_name) do
      {:ok, message} ->
        push(socket, "new_message", %{message: message})
        {:noreply, socket}

      :empty ->
        {:reply, {:error, "No messages"}, socket}
    end
  end
end
