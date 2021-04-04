defmodule YebosterWeb.KnowledgeLive.FunFactComponent do
  @moduledoc """
  A Live component to show fun facts
  """

  use YebosterWeb, :live_component

  alias Yeboster.Knowledge

  @impl true
  def mount(socket) do
    fun_fact =
      if connected?(socket) do
        random_fact()
      else
        %{}
      end

    {:ok, assign(socket, fun_fact: fun_fact)}
  end

  @impl true
  def handle_event("load_another_fact", _value, socket) do
    {:noreply, assign(socket, fun_fact: random_fact())}
  end

  defp random_fact do
    Knowledge.get_random_fact()
  end
end
