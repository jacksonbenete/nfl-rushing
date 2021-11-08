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

  describe "integration tests filter_component (filter) vs body_component (table results)" do
    test "filter when filter_type is strict must render correct results", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/?filter_type=strict")

      assert has_element?(view, "tr", "Ezekiel Elliott")

      view
      |> form("#filter_player_form", input: %{"filter" => "shau"})
      |> render_change()

      assert has_element?(view, "tr", "Shaun Draughn")

      refute has_element?(view, "tr", "Ezekiel Elliott")  # not included
      refute has_element?(view, "tr", "Shane Vereen")     # strict, should not fetch
    end

    test "filter when filter_type is fuzzy must render correct results", %{conn: conn} do
      {:ok, view, html} = live(conn, "/?filter_type=fuzzy")

      assert has_element?(view, "tr", "Ezekiel Elliott")

      view
      |> form("#filter_player_form", input: %{"filter" => "shau"})
      |> render_change()

      assert has_element?(view, "tr", "Shaun Draughn")
      assert has_element?(view, "tr", "Shane Vereen")     # fuzzy, should fetch

      refute has_element?(view, "tr", "Ezekiel Elliott")  # not included
    end

  end

  describe "integration tests header_component (sorting) vs body_component (table results)" do
    test "YDS sorting (asc) should render correct results", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/?sort=total_yards&sort_order=desc")

      # Yds starts as desc, Ezekiel is currently top 10
      assert has_element?(view, "td", "Ezekiel Elliott")

      view
      |> element("#Yds", "")
      |> render_click

      assert has_element?(view, "td", "Sam Koch")
      refute has_element?(view, "td", "Ezekiel Elliott")
    end

    test "TD sorting (asc) should render correct results", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/?sort=total_touchdowns&sort_order=desc")

      assert has_element?(view, "td", "LeGarrette Blount")

      view
      |> element("#TD", "")
      |> render_click

      assert has_element?(view, "td", "Randall Cobb")
      refute has_element?(view, "td", "LeGarrette Blount")
    end

    test "LNG sorting (asc) should render correct results", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/?sort=longest_rush&sort_order=desc")

      assert has_element?(view, "td", "Isaiah Crowell")

      view
      |> element("#Lng", "")
      |> render_click

      assert has_element?(view, "td", "Taiwan Jones")
      refute has_element?(view, "td", "Isaiah Crowell")
    end
  end

  describe "integration tests pagination_component vs body_component (table results)" do
    test "page 1 when rendering all results with default filters when next button is clicked should render correct table results", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/?filter=&filter_type=strict&page=1&page_size=10&sort=total_yards&sort_order=desc")

      assert has_element?(view, "td", "Ezekiel Elliott")

      view
      |> element("button[id=\"next_page_button\"]", "Next")
      |> render_click

      assert has_element?(view, "td", "Mark Ingram")
      refute has_element?(view, "td", "Ezekiel Elliott")
    end

    test "page 22 when rendering all results with default filters when previous button is clicked should render correct table results", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/?filter=&filter_type=strict&page=22&page_size=10&sort=total_yards&sort_order=desc")

      assert has_element?(view, "td", "Terrence Magee")

      view
      |> element("button[id=\"previous_page_button\"]", "Prev")
      |> render_click

      assert has_element?(view, "td", "Marc Mariani")
      refute has_element?(view, "td", "Terrence Magee")
    end
  end
end
