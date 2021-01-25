defmodule Demo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      DemoWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Demo.PubSub},
      # Start the Endpoint (http/https)
      DemoWeb.Endpoint
      # Start a worker by calling: Demo.Worker.start_link(arg)
      # {Demo.Worker, arg}
    ]

    # start_browser_command =
    #   case :os.type do
    #     {:win32, _} ->
    #       "start"
    #     {:unix, :darwin} ->
    #       "open"
    #     {:unix, _} ->
    #       "xdg-open"
    #   end

    # if System.find_executable(start_browser_command) do
    #   System.cmd(start_browser_command, ["http://localhost:4000"])
    # else
    #   Mix.raise "Command not found: #{start_browser_command}"
    # end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Demo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
