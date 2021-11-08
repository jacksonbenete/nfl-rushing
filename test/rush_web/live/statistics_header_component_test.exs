defmodule RushWeb.StatisticsHeaderComponentTest do
  use RushWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias RushWeb.StatisticsHeaderComponent

  describe "render/3 with sort_order: desc" do
    test "render/3 when receive total_yards and desc should render total_yards with ↓ arrow and asc sort_order" do
      table_header =
      """
      <tr class="text-md font-semibold tracking-wide text-left text-gray-900 bg-gray-100 uppercase border-b border-gray-600">
      <th class="px-4 py-3" id="Player">Name</th>
      <th class="px-4 py-3 text-blue-600" style="cursor: pointer" id="Yds" phx-click="sort_statistics" phx-value-sort="total_yards" phx-value-sort_order="asc">Yds\n↓\n</th>
      <th class="px-4 py-3 text-blue-600" style="cursor: pointer" id="TD" phx-click="sort_statistics" phx-value-sort="total_touchdowns" phx-value-sort_order="asc">TD\n\n</th>
      <th class="px-4 py-3 text-blue-600" style="cursor: pointer" id="Lng" phx-click="sort_statistics" phx-value-sort="longest_rush" phx-value-sort_order="asc">Lng\n\n</th>
      <th class="px-4 py-3" id="Att">Att</th>
      <th class="px-4 py-3" id="Avg">Avg</th>
      <th class="px-4 py-3 hidden sm:table-cell" id="Att/G">Att/G</th>
      <th class="px-4 py-3 hidden sm:table-cell" id="Yds/G">Yds/G</th>
      <th class="px-4 py-3 hidden sm:table-cell" id="1st">1st</th>
      <th class="px-4 py-3 hidden sm:table-cell" id="1st%">1st%</th>
      <th class="px-4 py-3 hidden sm:table-cell" id="20+">20+</th>
      <th class="px-4 py-3 hidden sm:table-cell" id="40+">40+</th>
      <th class="px-4 py-3 hidden sm:table-cell" id="Fum">Fum</th>
      </tr>
      """

      result = render_component(StatisticsHeaderComponent, sort: %{sort: "total_yards", sort_order: "desc"})

      assert result == table_header
    end

    test "render/3 when receive total_touchdowns and desc should render total_touchdowns with ↓ arrow and asc sort_order" do
      table_header =
        """
        <tr class="text-md font-semibold tracking-wide text-left text-gray-900 bg-gray-100 uppercase border-b border-gray-600">
        <th class="px-4 py-3" id="Player">Name</th>
        <th class="px-4 py-3 text-blue-600" style="cursor: pointer" id="Yds" phx-click="sort_statistics" phx-value-sort="total_yards" phx-value-sort_order="asc">Yds\n\n</th>
        <th class="px-4 py-3 text-blue-600" style="cursor: pointer" id="TD" phx-click="sort_statistics" phx-value-sort="total_touchdowns" phx-value-sort_order="asc">TD\n↓\n</th>
        <th class="px-4 py-3 text-blue-600" style="cursor: pointer" id="Lng" phx-click="sort_statistics" phx-value-sort="longest_rush" phx-value-sort_order="asc">Lng\n\n</th>
        <th class="px-4 py-3" id="Att">Att</th>
        <th class="px-4 py-3" id="Avg">Avg</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="Att/G">Att/G</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="Yds/G">Yds/G</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="1st">1st</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="1st%">1st%</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="20+">20+</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="40+">40+</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="Fum">Fum</th>
        </tr>
        """

      result = render_component(StatisticsHeaderComponent, sort: %{sort: "total_touchdowns", sort_order: "desc"})

      assert result == table_header
    end

    test "render/3 when receive longest_rush and desc should render longest_rush with ↓ arrow and asc sort_order" do
      table_header =
        """
        <tr class="text-md font-semibold tracking-wide text-left text-gray-900 bg-gray-100 uppercase border-b border-gray-600">
        <th class="px-4 py-3" id="Player">Name</th>
        <th class="px-4 py-3 text-blue-600" style="cursor: pointer" id="Yds" phx-click="sort_statistics" phx-value-sort="total_yards" phx-value-sort_order="asc">Yds\n\n</th>
        <th class="px-4 py-3 text-blue-600" style="cursor: pointer" id="TD" phx-click="sort_statistics" phx-value-sort="total_touchdowns" phx-value-sort_order="asc">TD\n\n</th>
        <th class="px-4 py-3 text-blue-600" style="cursor: pointer" id="Lng" phx-click="sort_statistics" phx-value-sort="longest_rush" phx-value-sort_order="asc">Lng\n↓\n</th>
        <th class="px-4 py-3" id="Att">Att</th>
        <th class="px-4 py-3" id="Avg">Avg</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="Att/G">Att/G</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="Yds/G">Yds/G</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="1st">1st</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="1st%">1st%</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="20+">20+</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="40+">40+</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="Fum">Fum</th>
        </tr>
        """

      result = render_component(StatisticsHeaderComponent, sort: %{sort: "longest_rush", sort_order: "desc"})

      assert result == table_header
    end
  end

  describe "render/3 with sort_order: asc" do
    test "render/3 when receive total_yards asc params should render total_yards with ↑ arrow and desc sort_order" do
      table_header =
        """
        <tr class="text-md font-semibold tracking-wide text-left text-gray-900 bg-gray-100 uppercase border-b border-gray-600">
        <th class="px-4 py-3" id="Player">Name</th>
        <th class="px-4 py-3 text-blue-600" style="cursor: pointer" id="Yds" phx-click="sort_statistics" phx-value-sort="total_yards" phx-value-sort_order="desc">Yds\n↑\n</th>
        <th class="px-4 py-3 text-blue-600" style="cursor: pointer" id="TD" phx-click="sort_statistics" phx-value-sort="total_touchdowns" phx-value-sort_order="desc">TD\n\n</th>
        <th class="px-4 py-3 text-blue-600" style="cursor: pointer" id="Lng" phx-click="sort_statistics" phx-value-sort="longest_rush" phx-value-sort_order="desc">Lng\n\n</th>
        <th class="px-4 py-3" id="Att">Att</th>
        <th class="px-4 py-3" id="Avg">Avg</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="Att/G">Att/G</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="Yds/G">Yds/G</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="1st">1st</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="1st%">1st%</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="20+">20+</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="40+">40+</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="Fum">Fum</th>
        </tr>
        """

      result = render_component(StatisticsHeaderComponent, sort: %{sort: "total_yards", sort_order: "asc"})

      assert result == table_header
    end

    test "render/3 when receive total_touchdown asc params should render total_touchdown with ↑ arrow and desc sort_order" do
      table_header =
        """
        <tr class="text-md font-semibold tracking-wide text-left text-gray-900 bg-gray-100 uppercase border-b border-gray-600">
        <th class="px-4 py-3" id="Player">Name</th>
        <th class="px-4 py-3 text-blue-600" style="cursor: pointer" id="Yds" phx-click="sort_statistics" phx-value-sort="total_yards" phx-value-sort_order="desc">Yds\n\n</th>
        <th class="px-4 py-3 text-blue-600" style="cursor: pointer" id="TD" phx-click="sort_statistics" phx-value-sort="total_touchdowns" phx-value-sort_order="desc">TD\n↑\n</th>
        <th class="px-4 py-3 text-blue-600" style="cursor: pointer" id="Lng" phx-click="sort_statistics" phx-value-sort="longest_rush" phx-value-sort_order="desc">Lng\n\n</th>
        <th class="px-4 py-3" id="Att">Att</th>
        <th class="px-4 py-3" id="Avg">Avg</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="Att/G">Att/G</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="Yds/G">Yds/G</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="1st">1st</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="1st%">1st%</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="20+">20+</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="40+">40+</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="Fum">Fum</th>
        </tr>
        """

      result = render_component(StatisticsHeaderComponent, sort: %{sort: "total_touchdowns", sort_order: "asc"})

      assert result == table_header
    end

    test "render/3 when receive longest_rush asc params should render longest_rush with ↑ arrow and desc sort_order" do
      table_header =
        """
        <tr class="text-md font-semibold tracking-wide text-left text-gray-900 bg-gray-100 uppercase border-b border-gray-600">
        <th class="px-4 py-3" id="Player">Name</th>
        <th class="px-4 py-3 text-blue-600" style="cursor: pointer" id="Yds" phx-click="sort_statistics" phx-value-sort="total_yards" phx-value-sort_order="desc">Yds\n\n</th>
        <th class="px-4 py-3 text-blue-600" style="cursor: pointer" id="TD" phx-click="sort_statistics" phx-value-sort="total_touchdowns" phx-value-sort_order="desc">TD\n\n</th>
        <th class="px-4 py-3 text-blue-600" style="cursor: pointer" id="Lng" phx-click="sort_statistics" phx-value-sort="longest_rush" phx-value-sort_order="desc">Lng\n↑\n</th>
        <th class="px-4 py-3" id="Att">Att</th>
        <th class="px-4 py-3" id="Avg">Avg</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="Att/G">Att/G</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="Yds/G">Yds/G</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="1st">1st</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="1st%">1st%</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="20+">20+</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="40+">40+</th>
        <th class="px-4 py-3 hidden sm:table-cell" id="Fum">Fum</th>
        </tr>
        """

      result = render_component(StatisticsHeaderComponent, sort: %{sort: "longest_rush", sort_order: "asc"})

      assert result == table_header
    end
  end

  describe "render_click" do
    test "render/3 when click desc total_yards should render asc total_yards", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/?sort=total_yards&sort_order=desc")

      assert has_element?(view, "#Yds", "Yds\n↓\n")

      view
      |> element("#Yds", "")
      |> render_click

      assert has_element?(view, "#Yds", "Yds\n↑\n")
    end

    test "render/3 when click asc total_yards should render desc total_yards", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/?sort=total_yards&sort_order=asc")

      assert has_element?(view, "#Yds", "Yds\n↑\n")

      view
      |> element("#Yds", "")
      |> render_click

      assert has_element?(view, "#Yds", "Yds\n↓\n")
    end

    test "render/3 when click desc total_touchdowns should render asc total_touchdowns", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/?sort=total_touchdowns&sort_order=desc")

      assert has_element?(view, "#TD", "TD\n↓\n")

      view
      |> element("#TD", "")
      |> render_click

      assert has_element?(view, "#TD", "TD\n↑\n")
    end

    test "render/3 when click asc total_touchdowns should render desc total_touchdowns", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/?sort=total_touchdowns&sort_order=asc")

      assert has_element?(view, "#TD", "TD\n↑\n")

      view
      |> element("#TD", "")
      |> render_click

      assert has_element?(view, "#TD", "TD\n↓\n")
    end

    test "render/3 when click desc longest_rush should render asc longest_rush", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/?sort=longest_rush&sort_order=desc")

      assert has_element?(view, "#Lng", "Lng\n↓\n")

      view
      |> element("#Lng", "")
      |> render_click

      assert has_element?(view, "#Lng", "Lng\n↑\n")
    end

    test "render/3 when click asc longest_rush should render desc longest_rush", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/?sort=longest_rush&sort_order=asc")

      assert has_element?(view, "#Lng", "Lng\n↑\n")

      view
      |> element("#Lng", "")
      |> render_click

      assert has_element?(view, "#Lng", "Lng\n↓\n")
    end
  end
end
