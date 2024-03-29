defmodule YebosterWeb.KnowledgeLive.FunFactComponent do
  @moduledoc """
  A Live component to show fun facts
  """

  use YebosterWeb, :live_component

  alias Yeboster.Repo
  alias Yeboster.Knowledge.{Category, FunFact, Emoji}

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign(emojis: Emoji.selected())
      |> assign(categories: Category.Query.all())
      |> assign(selected_category: nil)

    {:ok, socket}
  end

  @impl true
  def update(%{fact_id: fact_id}, socket) when is_integer(fact_id) do
    fun_fact =
      if connected?(socket) do
        case FunFact.Query.get_id(fact_id) do
          %FunFact{} = fact ->
            fact

          _ ->
            FunFact.Query.get_random_fact()
        end
      else
        %{}
      end

    {:ok, assign(socket, fun_fact: fun_fact)}
  end

  @impl true
  def update(_assigns, socket) do
    fun_fact =
      if connected?(socket) do
        FunFact.Query.get_random_fact()
      else
        %{}
      end

    {:ok, assign(socket, fun_fact: fun_fact)}
  end

  @impl true
  def handle_event("change_id", %{"fact_id" => id}, socket) do
    fact =
      with {int, _} <- Integer.parse(id),
           fact = %FunFact{} <- FunFact.Query.get_id(int) do
        fact
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
  def handle_event("remove_emoji", %{"emoji-index" => emoji_index}, socket) do
    fun_fact =
      case Integer.parse(emoji_index) do
        {index, _} ->
          socket.assigns.fun_fact
          |> FunFact.Query.remove_reaction_at!(index)

        _ ->
          socket.assigns.fun_fact
      end

    {:noreply, assign(socket, fun_fact: fun_fact)}
  end

  defp selected_attr(row, selected) do
    if row == selected do
      "selected"
    end
  end

  defp copy_fact_url_to_clipboard(socket, fact_id) do
    "window.app_utils.copyAndAlert('" <> Routes.knowledge_url(socket, :index, fact_id: fact_id) <> "')"
  end

  defdelegate render_emoji(emoji), to: Emoji

  defp fun_fact_meta_msg(%FunFact{date: date, source: source}) do
    formatted = "#{date.day}/#{date.month}/#{date.year}"
    "#{source} posted on #{formatted}"
  end

  defp fun_fact_meta_msg(_any), do: ""
end
