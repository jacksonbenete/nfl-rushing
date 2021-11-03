defmodule RushWeb.PlayerRegistrationControllerTest do
  use ExUnit.Case, async: true

  alias Ecto.Adapters.SQL.Sandbox
  alias RushWeb.Controllers.Json
  alias RushWeb.PlayerRegistrationController

  describe "map_to_player/1" do
    test "map_to_player/1 when receiving a valid map returns a valid player" do
      # Arrange
      data = "{\n    \"Player\":\"Joe Banyard\",\n    \"Team\":\"JAX\",\n    \"Pos\":\"RB\",\n    \"Att\":2,\n    \"Att/G\":2,\n    \"Yds\":7,\n    \"Avg\":3.5,\n    \"Yds/G\":7,\n    \"TD\":0,\n    \"Lng\":\"7\",\n    \"1st\":0,\n    \"1st%\":0,\n    \"20+\":0,\n    \"40+\":0,\n    \"FUM\":0\n  }"
      map = Json.json_to_map(data)

      # Act
      result = PlayerRegistrationController.map_to_player(map)

      # Assert
      assert %{
      "name" => "Joe Banyard",
      "team" => "JAX",
      "position" => "RB",
      "attempts_per_game" => 2,
      "attempts" => 2,
      "total_yards" => 7,
      "average_yards_per_attempt" => 3.5,
      "yards_per_game" => 7,
      "total_touchdowns" => 0,
      "longest_rush" => 7,
      "longest_rush_is_touchdown" => :false,
      "total_first_downs" => 0,
      "first_downs_percentage" => 0,
      "rush_20_plus" => 0,
      "rush_40_plus" => 0,
      "fumbles" => 0
      } == result
    end

    test "map_to_player/1 when receiving a LNG with touchdown returns a valid contract" do
      # Arrange
      data = "{\n  \"Player\":\"Mark Ingram\",\n  \"Team\":\"NO\",\n  \"Pos\":\"RB\",\n  \"Att\":205,\n  \"Att/G\":12.8,\n  \"Yds\":\"1,043\",\n  \"Avg\":5.1,\n  \"Yds/G\":65.2,\n  \"TD\":6,\n  \"Lng\":\"75T\",\n  \"1st\":49,\n  \"1st%\":23.9,\n  \"20+\":4,\n  \"40+\":2,\n  \"FUM\":2\n}"
      map = Json.json_to_map(data)

      # Act
      result = PlayerRegistrationController.map_to_player(map)

      # Assert
      assert %{
       "name" => "Mark Ingram",
       "team" => "NO",
       "position" => "RB",
       "attempts_per_game" => 12.8,
       "attempts" => 205,
       "total_yards" => 1043,
       "average_yards_per_attempt" => 5.1,
       "yards_per_game" => 65.2,
       "total_touchdowns" => 6,
       "longest_rush" => 75,
       "longest_rush_is_touchdown" => :true,
       "total_first_downs" => 49,
       "first_downs_percentage" => 23.9,
       "rush_20_plus" => 4,
       "rush_40_plus" => 2,
       "fumbles" => 2
       } == result
    end

    test "map_to_player/1 when receiving and empty map should return an empty map" do
      # Arrange
      map = %{}

      # Act
      result = PlayerRegistrationController.map_to_player(map)

      # Assert
      assert %{} = result
    end
  end

  describe "insert_player/1" do

    setup do
      :ok = Sandbox.checkout(Rush.Repo)
    end

    test "insert_player/1 when receive a valid player map will persist on database" do
      # Arrange
      data = "{\n    \"Player\":\"Joe Banyard\",\n    \"Team\":\"JAX\",\n    \"Pos\":\"RB\",\n    \"Att\":2,\n    \"Att/G\":2,\n    \"Yds\":7,\n    \"Avg\":3.5,\n    \"Yds/G\":7,\n    \"TD\":0,\n    \"Lng\":\"7\",\n    \"1st\":0,\n    \"1st%\":0,\n    \"20+\":0,\n    \"40+\":0,\n    \"FUM\":0\n  }"
      map = Json.json_to_map(data)
      valid_player = PlayerRegistrationController.map_to_player(map)

      # Act
      result = PlayerRegistrationController.insert_player(valid_player)

      # Assert
      assert {:ok, _res} = result

    end

    test "insert_player/1 when receive a valid contract with missing fields fail to persist" do
      # Arrange (missing "first_downs_percentage")
      invalid_player = %{
        "attempts" => 2,
        "attempts_per_game" => 2,
        "average_yards_per_attempt" => 3.5,
        "fumbles" => 0,
        "longest_rush" => 7,
        "longest_rush_is_touchdown" => false,
        "name" => "Joe Banyard",
        "position" => "RB",
        "rush_20_plus" => 0,
        "rush_40_plus" => 0,
        "team" => "JAX",
        "total_first_downs" => 0,
        "total_touchdowns" => 0,
        "total_yards" => 7,
        "yards_per_game" => 7
      }

      # Act
      {:error, :player_statistics, changeset, _} = PlayerRegistrationController.insert_player(invalid_player)
      result = changeset.valid?

      # Assert
      refute result
    end

    test "insert_player/1 when receive a valid contract with invalid fields fail to persist" do
      # Arrange "first_downs_percentage" should not be null
      invalid_player = %{
        "attempts" => 2,
        "attempts_per_game" => 2,
        "average_yards_per_attempt" => 3.5,
        "first_downs_percentage" => :nil,
        "fumbles" => 0,
        "longest_rush" => 7,
        "longest_rush_is_touchdown" => false,
        "name" => "Joe Banyard",
        "position" => "RB",
        "rush_20_plus" => 0,
        "rush_40_plus" => 0,
        "team" => "JAX",
        "total_first_downs" => 0,
        "total_touchdowns" => 0,
        "total_yards" => 7,
        "yards_per_game" => 7
      }

      # Act
      {:error, :player_statistics, changeset, _} = PlayerRegistrationController.insert_player(invalid_player)
      result = changeset.valid?

      # Assert
      refute result
    end

    test "insert_player/1 when receive an invalid contract map fail to persist" do
      # Arrange
      data = "{\n    \"Player\":\"Joe Banyard\",\n    \"Team\":\"JAX\",\n    \"Pos\":\"RB\",\n    \"Att\":2,\n    \"Att/G\":2,\n    \"Yds\":7,\n    \"Avg\":3.5,\n    \"Yds/G\":7,\n    \"TD\":0,\n    \"Lng\":\"7\",\n    \"1st\":0,\n    \"1st%\":0,\n    \"20+\":0,\n    \"40+\":0,\n    \"FUM\":0\n  }"
      invalid_map = Json.json_to_map(data)

      # Act
      {:error, :players, changeset, _} = PlayerRegistrationController.insert_player(invalid_map)
      result = changeset.valid?

      # Assert
      refute result
    end

  end
end
