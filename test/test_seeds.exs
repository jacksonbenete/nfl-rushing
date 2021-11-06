data = Rush.Json.import_json_file("test/test_data.json")
Enum.map(data, fn entry ->
  RushWeb.PlayerRegistrationController.create_player_from_map(entry)
  |> RushWeb.PlayerRegistrationController.insert_player
end)
