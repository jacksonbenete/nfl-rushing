defmodule RushWeb.StatisticsFilterComponentTest do
  use RushWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "render/3" do
    test "render/3 when not receiving params should returns an empty input search field", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      assert has_element?(view, "#filter_player_input", "")
    end

    test "render/3 when receiving params should return an input with value as param", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/?filter=joe")

      assert has_element?(view, "#filter_player_input[value=\"joe\"]")
      refute has_element?(view, "#filter_player_input[value=\"mark\"]")
    end
  end

  describe "render_change/1" do
    test "render_change/1 when submitting form filter_player_input must contain submitted value", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      view
      |> form("#filter_player_form", input: %{"filter" => "joe"})
      |> render_change()

      assert has_element?(view, "#filter_player_input[value=\"joe\"]")
      refute has_element?(view, "#filter_player_input[value=\"mark\"]")
    end
  end
end
