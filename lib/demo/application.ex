defmodule Demo.Application do
  @moduledoc false

  use Application

  require Logger

  def start(_type, _args) do
    children = [
      DemoWeb.Telemetry,
      {Phoenix.PubSub, name: Demo.PubSub},
      DemoWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Demo.Supervisor]
    result = Supervisor.start_link(children, opts)

    operative_system = :os.type
    start_browser_command = browser_start_cmd(operative_system)


    if System.find_executable(start_browser_command) do
      System.cmd(start_browser_command, browser_start_args(operative_system))
    else
      Logger.warn("Unable to open browser window, user needs to open it manually by going to #{DemoWeb.Endpoint.url()}")
    end

    result
  end

  def config_change(changed, _new, removed) do
    DemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp browser_start_cmd({:win32, _}), do: "cmd.exe"
  defp browser_start_cmd({:unix, :darwin}), do: "open"
  defp browser_start_cmd({:unix, _}), do: "xdg-open"

  defp browser_start_args({:win32, _}), do: ["/C", "start", DemoWeb.Endpoint.url()]
  defp browser_start_args({:unix, _}), do: [DemoWeb.Endpoint.url()]

end
