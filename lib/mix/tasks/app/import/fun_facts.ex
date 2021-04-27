defmodule Mix.Tasks.App.Import.FunFacts do
  use Mix.Task

  alias Yeboster.Knowledge.FunFact.Importer

  @default_path "/assets/json/google_facts.json"

  @shortdoc "Import fun facts from given path or default file in #{@default_path}"
  def run(args) do
    Mix.Task.run("app.start", [])

    case args do
      [path | _] when is_bitstring(path) ->
        if Path.expand(path) |> File.exists?() do
          IO.puts("Importing fun facts...")
          Importer.import_google_facts(path)
        else
          raise "The file #{path} does not exists."
        end

      _ ->
        IO.puts("Importing fun facts from default path #{@default_path}")
        Importer.import_google_facts()
    end
  end
end
