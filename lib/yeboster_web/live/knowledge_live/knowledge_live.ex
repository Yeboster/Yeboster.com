defmodule YebosterWeb.KnowledgeLive do
  @moduledoc """
  Live view to show some knowledge as fun_facts
  """

  use YebosterWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(fact_id: nil, page_title: "Inspiration")

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"fact_id" => fact_id}, _url, socket) do
    socket =
      case Integer.parse(fact_id) do
        {int, _} ->
          socket
          |> assign(fact_id: int)

        _ ->
          socket
      end

    {:noreply, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end
end
