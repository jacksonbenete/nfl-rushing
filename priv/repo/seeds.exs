# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rush.Repo.insert!(%Rush.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

data = RushWeb.Controllers.Json.import_json_file("priv/repo/rushing.json")
Enum.map(data, fn entry ->
  RushWeb.PlayerRegistrationController.map_to_player(entry)
  |> RushWeb.PlayerRegistrationController.insert_player
end)