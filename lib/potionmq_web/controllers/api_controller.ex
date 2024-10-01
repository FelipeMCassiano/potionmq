defmodule PotionmqWeb.ApiController do
  use PotionmqWeb, :controller

  def fetch_message(conn, %{"queue_name" => queue_name}) do
    case Potionmq.MessageQueue.QueueServer.fetch_message(queue_name) do
      {:ok, message} ->
        conn |> put_status(200) |> json(message)
    end
  end

  def add_message(conn, %{"queue_name" => queue_name, "message" => message}) do
    Potionmq.MessageQueue.QueueServer.add_message(queue_name, message)
    conn |> put_status(200)
  end
end
