defmodule YebosterWeb.KnowledgeLive.FunFactComponent do
  @moduledoc """
  A Live component to show fun facts
  """

  use YebosterWeb, :live_component

  alias Yeboster.Repo
  alias Yeboster.Knowledge.{Category, FunFact, Emoji}

  @impl true
  def mount(socket) do
    fun_fact =
      if connected?(socket) do
        FunFact.Query.get_random_fact()
      else
        %{}
      end

    socket =
      socket
      |> assign(fun_fact: fun_fact)
      |> assign(emojis: Emoji.selected())
      |> assign(categories: Category.Query.all())
      |> assign(selected_category: nil)

    {:ok, socket}
  end

  @impl true
  def handle_event("change_id", %{"id" => id}, socket) do
    fact =
      with {int, _} <- Integer.parse(id),
           fact = %FunFact{} <- FunFact.Query.get_id(int) do
        fact
        |> FunFact.Query.increase_fact_show_count!()
      else
        _ -> socket.assigns.fun_fact
      end

    {:noreply, assign(socket, fun_fact: fact)}
  end

  @impl true
  def handle_event("load_another_fact", _value, socket) do
    fact =
      case socket.assigns.selected_category do
        category = %Category{} ->
          FunFact.Query.get_fact_with(category)

        nil ->
          FunFact.Query.get_random_fact()
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
            FunFact.Query.get_fact_with(category)
          else
            fun_fact
          end

        _ ->
          FunFact.Query.get_fact_with(category)
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
      |> FunFact.Query.add_reaction!(emoji)

    socket =
      socket
      |> assign(fun_fact: fun_fact)

    {:noreply, socket}
  end

  @impl true
  def handle_event("remove_emoji", %{"emoji" => emoji}, socket) do
    fun_fact =
      socket.assigns.fun_fact
      |> FunFact.Query.remove_reaction!(emoji)

    {:noreply, assign(socket, fun_fact: fun_fact)}
  end

  defp selected_attr(row, selected) do
    if row == selected do
      "selected"
    end
  end

  defdelegate render_emoji(emoji), to: Emoji

  defp fun_fact_meta_msg(%FunFact{date: date, source: source}) do
    formatted = "#{date.day}/#{date.month}/#{date.year}"
    "#{source} posted on #{formatted}"
  end

  defp fun_fact_meta_msg(_any), do: ""
end
