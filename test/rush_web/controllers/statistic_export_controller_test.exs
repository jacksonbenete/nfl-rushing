defmodule RushWeb.StatisticExportControllerTest do
  use RushWeb.ConnCase

  alias Ecto.Adapters.SQL.Sandbox
  alias Rush.Repo
  alias RushWeb.StatisticExportController

  describe "export_csv/2" do

    setup do
      :ok = Sandbox.checkout(Repo)
    end

    test "export_csv/2 when not receiving params should download all players", %{conn: conn} do
      # Arrange
      params = %{}

      # Act
      result = StatisticExportController.export_csv(conn, params)
      list_size = csv_to_list(result.resp_body) |> length

      # Assert (-1 discount headers)
      assert 326 == list_size - 1
    end

    test "export_csv/2 when receiving params should download only filtered players", %{conn: conn} do
      # Arrange
      params = %{"filter" => "joe"}

      # Act
      result = StatisticExportController.export_csv(conn, params)
      list_size = csv_to_list(result.resp_body) |> length

      # Assert (-1 discount headers)
      assert 3 = list_size - 1
    end
  end

  @doc """
  Those tests describe why using fuzzy filter is a bad idea.
  """
  describe "fuzzy filter export" do
    test "export_csv/2 when receiving fuzzy filter with valid string should filter correctly", %{conn: conn} do
      # Arrange
      params = %{"filter" => "shau", "filter_type" => "fuzzy"}

      # Act
      result = StatisticExportController.export_csv(conn, params)
      list_size = csv_to_list(result.resp_body) |> length

      # Assert (-1 discount headers)
      assert 4 = list_size - 1
    end

    test "export_csv/2 when receiving fuzzy filter with empty string will return nothing", %{conn: conn} do
      # Arrange
      params = %{"filter" => "", "filter_type" => "fuzzy"}

      # Act
      result = StatisticExportController.export_csv(conn, params)
      list_size = csv_to_list(result.resp_body) |> length

      # Assert (-1 discount headers)
      assert 0 = list_size - 1
    end

    test "export_csv/2 when receiving fuzzy filter with a small string results will differ from strict filter", %{conn: conn} do
      # Arrange
      params = %{"filter" => "jo", "filter_type" => "fuzzy"}

      # Act
      result = StatisticExportController.export_csv(conn, params)
      list_size = csv_to_list(result.resp_body) |> length

      # Assert (strict for "jo" would return 18 rows)
      assert 2 = list_size - 1
    end
  end

  defp csv_to_list(data) do
    data
    |> String.split("\r\n")
    |> CSV.decode(headers: true)
    |> Enum.to_list
  end
end
