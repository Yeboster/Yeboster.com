defmodule Yeboster.Knowledge.FunFact.Importer do
  alias Yeboster.Repo
  alias Yeboster.Knowledge

  def import_google_facts(path \\ "./assets/json/google_facts.json")

  @doc """
  Import Google facts, from json file
  ## Json Structure
  %{"message" => "this is a fact #category", "date" => DateTime}
  """
  def import_google_facts(path) when is_bitstring(path) do
    full_path = Path.expand(path)

    with {:ok, content} <- File.read(full_path) do
      with {:ok, json} <- Jason.decode(content) do
        import_google_facts(json)
      end
    end
  end

  def import_google_facts(list) when is_list(list) do
    Enum.map(list, &import_google_fact/1)
  end

  @doc """
  Import googlefactss from map
  ## Examples
  import_google_fact(%{"message" => "this is a fact #category", "date" => DateTime})
  """
  def import_google_fact(map) when is_map(map) do
    updated_map =
      case extract_data(map) do
        [tags: tags, map: updated] ->
          category_map =
            unless Enum.empty?(tags) do
              List.first(tags)
              |> extract_category_id
            else
              %{}
            end

          updated
          |> Map.merge(category_map)

        [map: updated] ->
          updated
      end

    case Knowledge.create_fun_facts(updated_map) do
      {:error, changeset} ->
        errors_stringified =
          changeset.errors
          |> Enum.map(&Repo.changeset_error_to_string/1)
          |> Enum.join(",")

        {:error, "Map #{Jason.encode!(map)} is not valid because of: #{errors_stringified}"}

      fact ->
        fact
    end
  end

  defp extract_data(map) when is_map(map) do
    if Map.has_key?(map, "message") do
      [tags: tags, text: message] = extract_tags(map["message"])

      source = "@googlefactss"

      normalized_message =
        message
        |> String.replace(source, "")
        |> String.trim()

      add_date_if_parsed = fn map ->
        case DateTime.from_iso8601(map["date"]) do
          {:ok, date, _} ->
            map |> Map.replace("date", date)

          {:error, _} ->
            map
        end
      end

      updated_map =
        map
        |> Map.replace("message", normalized_message)
        |> add_date_if_parsed.()
        |> Map.merge(%{"source" => source})

      [tags: tags, map: updated_map]
    else
      [map: map]
    end
  end

  defp extract_category_id(tag) when is_bitstring(tag) do
    case Knowledge.find_by_category_or_create(%{name: tag}) do
      {:ok, category} ->
        %{"category_id" => category.id}

      _ ->
        %{}
    end
  end

  defp extract_tags(text) when is_bitstring(text) do
    # Do not use \w to avoid errors with emoji
    tags_pattern = ~r/#[a-zA-Z]+/

    tags =
      Regex.scan(tags_pattern, text)
      |> List.flatten()
      |> Enum.map(&String.replace(&1, "#", ""))

    cleaned =
      text
      |> String.replace(tags_pattern, "")

    [tags: tags, text: cleaned]
  end
end
