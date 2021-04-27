defmodule Yeboster.Knowledge.Emoji do
  @moduledoc """
  Manage emojis using Exmoji library
  """

  alias Exmoji.EmojiChar

  @happy_emojis ~w(😄 😆 😂 😎 ❤️  💡)
  @neutral_emojis ~w(😐 😅)
  @sad_emojis ~w(🙁 😭 😒 😱)

  def happy_emojis, do: @happy_emojis |> to_exmojis
  def neutral_emojis, do: @neutral_emojis |> to_exmojis
  def sad_emojis, do: @sad_emojis |> to_exmojis

  def to_exmojis(emojis) do
    emojis 
    |> Enum.map(&Exmoji.Scanner.scan/1)
    |> List.flatten
  end

  def selected, do: happy_emojis() ++ neutral_emojis() ++ sad_emojis()

  defdelegate all, to: Exmoji

  def render_emoji(emoji = %EmojiChar{}), do: EmojiChar.render(emoji)

  def render_emoji(emoji_name) when is_bitstring(emoji_name) do
    emoji_name
    |> Exmoji.from_short_name()
    |> render_emoji()
  end
end
