defmodule RushWeb.StatisticsBodyComponentTest do
  use RushWeb.ConnCase, async: true

  import Phoenix.ConnTest
  import Phoenix.LiveViewTest

  alias RushWeb.StatisticsBodyComponent

  describe "render/3" do
    test "render/3 when receive a valid player renders a row" do
      # Arrange
      valid_player = %{
      id: 1,
      name: "Mark Ingram",
      team: "NO",
      position: "RB",
      attempts_per_game: 12.8,
      attempts: 205,
      total_yards: 1043,
      average_yards_per_attempt: 5.1,
      yards_per_game: 65.2,
      total_touchdowns: 6,
      longest_rush: 75,
      longest_rush_is_touchdown: :true,
      total_first_downs: 49,
      first_downs_percentage: 23.9,
      rush_20_plus: 4,
      rush_40_plus: 2,
      fumbles: 2
      }

      # Act
      result = render_component(StatisticsBodyComponent, player: valid_player)

      # Assert
      assert result =~
      """
      <td class="px-4 py-3 text-ms font-semibold border" headers="Yds"> #{valid_player.total_yards} </td>
      <td class="px-4 py-3 text-ms font-semibold border" headers="TD"> #{valid_player.total_touchdowns} </td>
      <td class="px-4 py-3 text-ms font-semibold border" headers="Lng"> #{valid_player.longest_rush} </td>
      <td class="px-4 py-3 text-ms font-semibold border" headers="Att"> #{valid_player.attempts} </td>
      <td class="px-4 py-3 text-ms font-semibold border" headers="Avg"> #{valid_player.average_yards_per_attempt} </td>
      <td class="px-4 py-3 text-ms font-semibold border" headers="Att/G"> #{valid_player.attempts_per_game} </td>
      <td class="px-4 py-3 text-ms font-semibold border" headers="Yds/G"> #{valid_player.yards_per_game} </td>
      <td class="px-4 py-3 text-ms font-semibold border" headers="1st"> #{valid_player.total_first_downs} </td>
      <td class="px-4 py-3 text-ms font-semibold border" headers="1st%"> #{valid_player.first_downs_percentage}% </td>
      <td class="px-4 py-3 text-ms font-semibold border" headers="20+"> #{valid_player.rush_20_plus} </td>
      <td class="px-4 py-3 text-ms font-semibold border" headers="40+"> #{valid_player.rush_40_plus} </td>
      <td class="px-4 py-3 text-ms font-semibold border" headers="Fum"> #{valid_player.fumbles} </td>
      """
    end

    test "render/3 when receive an invalid player returns error" do
      # Arrange (missing id, are you sure it came from the database?)
      invalid_player = %{
        name: "Mark Ingram",
        team: "NO",
        position: "RB",
        attempts_per_game: 12.8,
        attempts: 205,
        total_yards: 1043,
        average_yards_per_attempt: 5.1,
        yards_per_game: 65.2,
        total_touchdowns: 6,
        longest_rush: 75,
        longest_rush_is_touchdown: :true,
        total_first_downs: 49,
        first_downs_percentage: 23.9,
        rush_20_plus: 4,
        rush_40_plus: 2,
        fumbles: 2
      }

      # Assert
      assert_raise KeyError, fn ->
        render_component(StatisticsBodyComponent, player: invalid_player)
      end
    end
  end
end