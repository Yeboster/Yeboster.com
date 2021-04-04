defmodule YebosterWeb.KnowledgeLive.Index do
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
    |> assign(fun_fact: random_fact())
  end

  @impl true
  def handle_event("load_another_fact", _value, socket) do
    {:noreply, assign(socket, fun_fact: random_fact())}
  end

  defp random_fact do
    Knowledge.get_random_fact()
  end
end
