# It could instead run inside an Ecto.Multi transaction, so if any data
# fail passes on anti-corruption layer, you may want to rollback and reject all
# insertions.
data = Rush.Json.import_json_file("priv/repo/rushing.json")
Enum.map(data, fn entry ->
  RushWeb.PlayerRegistrationController.create_player_from_map(entry)
  |> RushWeb.PlayerRegistrationController.insert_player
end)