defmodule Demo.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      DemoWeb.Telemetry,
      {Phoenix.PubSub, name: Demo.PubSub},
      DemoWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Demo.Supervisor]
    result = Supervisor.start_link(children, opts)

    start_browser_command =
      case :os.type do
        {:win32, _} ->
          "start"
        {:unix, :darwin} ->
          "open"
        {:unix, _} ->
          "xdg-open"
      end

    if System.find_executable(start_browser_command) do
      System.cmd(start_browser_command, [DemoWeb.Endpoint.url()])
    else
      Mix.raise "Command not found: #{start_browser_command}"
    end

    result
  end

  def config_change(changed, _new, removed) do
    DemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
