defmodule YebosterWeb.KnowledgeLive.FunFactComponent do
  @moduledoc """
  A Live component to show fun facts
  """

  use YebosterWeb, :live_component

  alias Yeboster.Repo
  alias Yeboster.Knowledge
  alias Yeboster.Knowledge.{Category, FunFact}
  alias Exmoji.EmojiChar

  @impl true
  def mount(socket) do
    fun_fact =
      if connected?(socket) do
        Knowledge.get_random_fact()
      else
        %{}
      end

    socket =
      socket
      |> assign(fun_fact: fun_fact)
      |> assign(all_emojis: Exmoji.all())
      |> assign(categories: Knowledge.get_all_categories())
      |> assign(selected_category: nil)

    {:ok, socket}
  end

  @impl true
  def handle_event("load_another_fact", _value, socket) do
    fact =
      case socket.assigns.selected_category do
        category = %Category{} ->
          get_fact_with(category)

        nil ->
          Knowledge.get_random_fact()
      end

    {:noreply, assign(socket, fun_fact: fact)}
  end

  @impl true
  def handle_event("change_category", %{"category" => name}, socket) do
    category = Category |> Repo.get_by!(%{name: name})

    fact =
      case socket.assigns.fun_fact do
        fun_fact = %FunFact{} ->
          if category.name != fun_fact.category.name do
            get_fact_with(category)
          else
            fun_fact
          end

        _ ->
          get_fact_with(category)
      end

    socket =
      socket
      |> assign(selected_category: category)
      |> assign(fun_fact: fact)

    {:noreply, socket}
  end

  @impl true
  def handle_event("add_emoji", %{"emoji" => ""}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("add_emoji", %{"emoji" => emoji}, socket) do
    fun_fact =
      socket.assigns.fun_fact
      |> Knowledge.add_reaction!(emoji)

    socket =
      socket
      |> assign(fun_fact: fun_fact)

    {:noreply, socket}
  end

  @impl true
  def handle_event("remove_emoji", %{"emoji" => emoji}, socket) do
    fun_fact =
      socket.assigns.fun_fact
      |> Knowledge.remove_reaction!(emoji)

    {:noreply, assign(socket, fun_fact: fun_fact)}
  end

  defp get_fact_with(category = %Knowledge.Category{}) do
    Knowledge.FunFact
    |> Knowledge.with_category(category)
    |> Knowledge.get_random_fact()
  end

  defp render_emoji(emoji = %EmojiChar{}), do: EmojiChar.render(emoji)

  defp render_emoji(emoji_name) when is_bitstring(emoji_name) do
    emoji_name
    |> Exmoji.from_short_name()
    |> render_emoji
  end

  defp selected_attr(row, selected) do
    if row == selected do
      "selected"
    end
  end
end
