defmodule RushWeb.StatisticsPaginationComponent do
  @moduledoc """
  The pagination works using Scrivener.Ecto and uses the update/2 function
  to receive the assigns given to the component and use the helper functions
  to update the assigns with additional parameters for styling the buttons conditionally.
  """
  use RushWeb, :live_component

  def update(assigns, socket) do
    {page, total_pages} = get_params(assigns)

    previous_button = get_previous_button_attrs(page, total_pages)
    next_button = get_next_button_attrs(page, total_pages)

    {:ok,
    socket
    |> assign(page: page, total_pages: total_pages,
              previous_button: previous_button, next_button: next_button)}
  end

  defp get_params(assigns) do
    {
      page = assigns.page,
      total_pages = assigns.total_pages
    }
  end

  defp get_previous_button_attrs(page, total_pages) do
    case page == 1 do
      true -> %{disabled: "disabled", css: "cursor: default", colour: "bg-gray-100"}
      _ -> %{disabled: "", css: "", colour: "bg-blue-500 hover:bg-gray-400"}
    end
  end

  defp get_next_button_attrs(page, total_pages) do
    case page == total_pages do
      true -> %{disabled: "disabled", css: "cursor: default", colour: "bg-gray-100"}
      _ -> %{disabled: "", css: "", colour: "bg-blue-500 hover:bg-gray-400"}
    end
  end
end
