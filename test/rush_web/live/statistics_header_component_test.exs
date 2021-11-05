defmodule RushWeb.StatisticsHeaderComponentTest do
  use RushWeb.ConnCase, async: true

  import Phoenix.ConnTest
  import Phoenix.LiveViewTest

  alias RushWeb.StatisticsHeaderComponent

  describe "render/3" do
    test "render/3 when receive get request renders a table header" do
      assert render_component(StatisticsHeaderComponent, %{}) =~
      """
      <tr class="text-md font-semibold tracking-wide text-left text-gray-900 bg-gray-100 uppercase border-b border-gray-600">
      <th class="px-4 py-3" id="Player">Name</th>
      <th class="px-4 py-3" id="Yds">Yds</th>
      <th class="px-4 py-3" id="TD">TD</th>
      <th class="px-4 py-3" id="Lng">Lng</th>
      <th class="px-4 py-3" id="Att">Att</th>
      <th class="px-4 py-3" id="Avg">Avg</th>
      <th class="px-4 py-3" id="Att/G">Att/G</th>
      <th class="px-4 py-3" id="Yds/G">Yds/G</th>
      <th class="px-4 py-3" id="1st">1st</th>
      <th class="px-4 py-3" id="1st%">1st%</th>
      <th class="px-4 py-3" id="20+">20+</th>
      <th class="px-4 py-3" id="40+">40+</th>
      <th class="px-4 py-3" id="Fum">Fum</th>
      </tr>
      """
    end
  end  
end