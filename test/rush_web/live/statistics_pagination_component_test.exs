defmodule RushWeb.StatisticsPaginationComponentTest do
  use RushWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "render/3" do
    test "render/3 when not receiving params should return page 1", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      assert has_element?(view, "#total_pages_button", "1/")
      refute has_element?(view, "#total_pages_button", "9/")
    end

    test "render/3 when receiving params should show param value as page", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/?page=22")

      assert has_element?(view, "#total_pages_button", "22/")
      refute has_element?(view, "#total_pages_button", "1/")
    end
  end

  describe "render_click/1" do
    test "render_click/1 when receiving callback should receive correct param", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      assert has_element?(view, "#total_pages_button", "1/")

      view
      |> element("button[id=\"next_page_button\"]", "Next")
      |> render_click

      assert has_element?(view, "#total_pages_button", "2/")
    end

    test "render_click/1 when page received param should render the correct next page", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/?page=12")

      assert has_element?(view, "#total_pages_button", "12/")

      view
      |> element("button[id=\"next_page_button\"]", "Next")
      |> render_click

      assert has_element?(view, "#total_pages_button", "13/")
    end

    test "render_click/1 when page received param should render the correct previous page", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/?page=21")

      assert has_element?(view, "#total_pages_button", "21/")

      view
      |> element("button[id=\"previous_page_button\"]", "Prev")
      |> render_click

      assert has_element?(view, "#total_pages_button", "20/")
    end
  end
end
