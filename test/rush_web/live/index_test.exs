defmodule RushWeb.IndexTest do
  use RushWeb.ConnCase, async: true

  alias Ecto.Adapters.SQL.Sandbox
  alias Rush.Json

  import Phoenix.LiveViewTest

  describe "index" do
    test "index when connected handle_params/3 should render table", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")

      assert html =~ "<tbody id=\"table-body\" class=\"bg-white\"><tr"
    end

    test "search input when receive a name should filter table", %{conn: conn} do
      # Arrange
      search_player_name = "Joe Banyard"
      another_player_name = "Ezekiel Elliott"

      # Act Assert (before searching can find another_player)
      {:ok, view, html} = live(conn, "/")
      assert html =~ another_player_name

      # Act Assert (after search can't find another_player)
      refute render_hook(view, :filter_player, %{input: %{filter: search_player_name}}) =~ another_player_name
      assert render_hook(view, :filter_player, %{input: %{filter: search_player_name}}) =~ search_player_name
    end
  end
end
