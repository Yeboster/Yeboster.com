defmodule YebosterWeb.KnowledgeLive.FunFactComponent do
  @moduledoc """
  A Live component to show fun facts
  """

  use YebosterWeb, :live_component

  alias Yeboster.Knowledge

  @impl true
  def mount(socket) do
    assigns =
      if connected?(socket) do
        assign(socket, fun_fact: random_fact())
      else
        assign(socket, fun_fact: %Knowledge.FunFact{})
      end

    {:ok, assigns}
  end

  @impl true
  def handle_event("load_another_fact", _value, socket) do
    {:noreply, assign(socket, fun_fact: random_fact())}
  end

  defp random_fact do
    Knowledge.get_random_fact()
  end
end
