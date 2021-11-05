defmodule RushWeb.IndexTest do
  use RushWeb.ConnCase, async: true

  import Phoenix.ConnTest
  import Phoenix.LiveViewTest

  describe "index" do
    test "disconnected and connected mount", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "</tbody>\n        </table>\n    </div>"

      {:ok, view, html} = live(conn)
    end

    test "search input when receive a name should filter table", %{conn: conn} do
      # Arrange
      search_player_name = "Joe Banyard"
      another_player_name = "Shaun Hill"

      # Act Assert (before searching can find another_player)
      {:ok, view, html} = live(conn, "/")
      assert html =~ another_player_name

      # Act Assert (after search can't find another_player)
      refute render_hook(view, :filter_player, %{filter: %{filter: search_player_name}}) =~ another_player_name
      assert render_hook(view, :filter_player, %{filter: %{filter: search_player_name}}) =~ search_player_name
    end
  end
end
