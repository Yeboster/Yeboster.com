defmodule YebosterWeb.KnowledgeLive.FunFactComponent do
  @moduledoc """
  A Live component to show fun facts
  """

  use YebosterWeb, :live_component

  alias Yeboster.Knowledge
  alias Exmoji.EmojiChar

  @impl true
  def mount(socket) do
    fun_fact =
      if connected?(socket) do
        random_fact()
      else
        %{}
      end

    socket =
      socket
      |> assign(fun_fact: fun_fact)
      |> assign(selected_emoji: nil)
      |> assign(all_emojis: Exmoji.all())

    {:ok, socket}
  end

  @impl true
  def handle_event("load_another_fact", _value, socket) do
    {:noreply, assign(socket, fun_fact: random_fact())}
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

    {:noreply, assign(socket, fun_fact: fun_fact)}
  end

  @impl true
  def handle_event("remove_emoji", %{"emoji" => emoji}, socket) do
    fun_fact =
      socket.assigns.fun_fact
      |> Knowledge.remove_reaction!(emoji)

    {:noreply, assign(socket, fun_fact: fun_fact)}
  end

  defp random_fact do
    Knowledge.get_random_fact()
  end

  defp render_emoji(emoji = %EmojiChar{}), do: EmojiChar.render(emoji)

  defp render_emoji(emoji_name) when is_bitstring(emoji_name) do
    emoji_name
    |> Exmoji.from_short_name()
    |> render_emoji
  end
end
