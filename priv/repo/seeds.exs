# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Yeboster.Repo.insert!(%Yeboster.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# TODO: Add ! fn
Yeboster.Knowledge.FunFact.Importer.import_google_facts()
