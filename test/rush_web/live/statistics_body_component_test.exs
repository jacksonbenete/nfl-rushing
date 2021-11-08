defmodule RushWeb.StatisticsBodyComponentTest do
  use RushWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias RushWeb.StatisticsBodyComponent

  describe "render/3" do
    test "render/3 when receive a valid player with longest_rush_is_touchdown as true renders a row correctly" do
      # Arrange
      valid_player = return_valid_player(:true)

      # Act
      result = render_component(StatisticsBodyComponent, player: valid_player, counter: 1)

      # Assert
      assert result =~
      """
      <td class="px-4 py-3 text-ms font-semibold border text-center" headers="Yds"> #{valid_player.total_yards} </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center" headers="TD"> #{valid_player.total_touchdowns} </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center text-red-500" headers="Lng"> #{valid_player.longest_rush} </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center" headers="Att"> #{valid_player.attempts} </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center" headers="Avg"> #{valid_player.average_yards_per_attempt} </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center hidden sm:table-cell" headers="Att/G"> #{valid_player.attempts_per_game} </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center hidden sm:table-cell" headers="Yds/G"> #{valid_player.yards_per_game} </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center hidden sm:table-cell" headers="1st"> #{valid_player.total_first_downs} </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center hidden sm:table-cell" headers="1st%"> #{valid_player.first_downs_percentage}% </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center hidden sm:table-cell" headers="20+"> #{valid_player.rush_20_plus} </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center hidden sm:table-cell" headers="40+"> #{valid_player.rush_40_plus} </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center hidden sm:table-cell" headers="Fum"> #{valid_player.fumbles} </td>
      """
    end

    test "render/3 when receive a valid player with longest_rush_is_touchdown as false renders a row with column text uncolored" do
      # Arrange
      valid_player = return_valid_player(:false)

      # Act
      result = render_component(StatisticsBodyComponent, player: valid_player, counter: 1)

      # Assert (notice the space in the end of Lng class"
      assert result =~
      """
      <td class="px-4 py-3 text-ms font-semibold border text-center" headers="Yds"> #{valid_player.total_yards} </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center" headers="TD"> #{valid_player.total_touchdowns} </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center " headers="Lng"> #{valid_player.longest_rush} </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center" headers="Att"> #{valid_player.attempts} </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center" headers="Avg"> #{valid_player.average_yards_per_attempt} </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center hidden sm:table-cell" headers="Att/G"> #{valid_player.attempts_per_game} </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center hidden sm:table-cell" headers="Yds/G"> #{valid_player.yards_per_game} </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center hidden sm:table-cell" headers="1st"> #{valid_player.total_first_downs} </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center hidden sm:table-cell" headers="1st%"> #{valid_player.first_downs_percentage}% </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center hidden sm:table-cell" headers="20+"> #{valid_player.rush_20_plus} </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center hidden sm:table-cell" headers="40+"> #{valid_player.rush_40_plus} </td>
      <td class="px-4 py-3 text-ms font-semibold border text-center hidden sm:table-cell" headers="Fum"> #{valid_player.fumbles} </td>
      """
    end

    test "render/3 when receive an odd counter renders row with gray background colour" do
      # Arrange
      valid_player = return_valid_player(:true)

      # Act
      result = render_component(StatisticsBodyComponent, player: valid_player, counter: 1)

      # Assert
      assert result =~ "<tr class=\"text-gray-700 bg-gray-100\" phx-value-id=\"#{valid_player.id}\">"
    end

    test "render/3 when receive an even counter renders row with default background colour" do
      # Arrange
      valid_player = return_valid_player(:true)

      # Act
      result = render_component(StatisticsBodyComponent, player: valid_player, counter: 2)

      # Assert (notice the space in the end of class"
      assert result =~ "<tr class=\"text-gray-700 \" phx-value-id=\"#{valid_player.id}\">"
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
        render_component(StatisticsBodyComponent, player: invalid_player, counter: 1)
      end
    end
  end

  defp return_valid_player(longest_rush_is_touchdown) do
    %{
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
      longest_rush_is_touchdown: longest_rush_is_touchdown,
      total_first_downs: 49,
      first_downs_percentage: 23.9,
      rush_20_plus: 4,
      rush_40_plus: 2,
      fumbles: 2
    }
  end
end
