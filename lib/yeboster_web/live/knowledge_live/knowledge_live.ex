defmodule YebosterWeb.KnowledgeLive do
  @moduledoc """
  Live view to show some knowledge as fun_facts
  """

  use YebosterWeb, :live_view

  alias Yeboster.Knowledge

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Inspiration")}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end
end
