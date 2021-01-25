defmodule DemoWeb.LightLive do
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :brightness, 10)
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style="width: <%= @brightness %> ">
          <%= @brightness %>
        </span>
      </div>

      <button phx-click="off">
        <img src="images/light-off.svg">
      </button>

      <button phx-click="on">
        <img src="images/light-on.svg">
      </button>
    </div>
    """
  end

  @impl true
  def handle_event("on", _metadata, socket) do
    assign(socket, :brightness, 100)
    {:noreply, socket}
  end

  def handle_event("off", _metadata, socket) do
    assign(socket, :brightness, 0)
    {:noreply, socket}
  end
end
