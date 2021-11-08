defmodule RushWeb.StatisticsDownloadComponentTest do
  use RushWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "render/3" do
    test "render/3 when loading page should render download csv button", %{conn: conn} do
      {:ok, view, html} = live(conn, "/")

      # Asserting the class we already know if the button will look like we expect
      assert html =~ "class=\"px-4 py-2 border rounded-md font-medium text-white bg-indigo-600 hover:bg-indigo-700\""

      assert has_element?(view, "a", "Download CSV")
    end

  end
end
