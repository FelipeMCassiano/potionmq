defmodule Potionmq.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  alias Potionmq.MessageQueue.QueueSupervisor

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PotionmqWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:potionmq, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Potionmq.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Potionmq.Finch},
      # Start a worker by calling: Potionmq.Worker.start_link(arg)
      # {Potionmq.Worker, arg},
      QueueSupervisor,
      # Start to serve requests, typically the last entry
      PotionmqWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Potionmq.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PotionmqWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
