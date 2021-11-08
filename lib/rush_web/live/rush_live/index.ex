defmodule RushWeb.RushLive.Index do
  @moduledoc """
  RushLive.Index is a module responsible for mounting, rendering and handling
  params and events for the NFL Rush application.
  Although LiveView files are normally a controller + view it can get messy,
  I thought the module was too big and decided to try the approach of using
  the "LiveView" literally as a View, we still have controllers and models.
  """
  use RushWeb, :live_view

  alias RushWeb.RushLive.Controller

  def mount(_params, _session, socket) do
    page_params = Controller.set_page_params
    {
      :ok,
      socket
      |> assign(page_params)
      |> Controller.validate_filter
    }
  end

  def handle_params(params, uri, socket) do
    page_params = Controller.set_page_params(params)
    url_params = URI.parse(uri).query

    {
      :noreply,
      socket
      |> assign(url_params: url_params)
      |> assign(page_params)
      |> Controller.validate_filter
      |> Controller.list_players
    }
  end

  def handle_event("filter_player", %{"input" => %{"filter" => query_string}}, socket) do
    page_params = Controller.update_page_params(socket, %{filter: query_string, page: 1})

    {
      :noreply,
      socket
      |> push_patch(to: Routes.rush_index_path(socket, :index, page_params))
    }
  end

  def handle_event("previous_page", _value, socket) do
    new_page = socket.assigns.page - 1
    page_params = Controller.update_page_params(socket, %{page: new_page})

    {
      :noreply,
      socket
      |> push_patch(to: Routes.rush_index_path(socket, :index, page_params))
    }
  end

  def handle_event("next_page", _value, socket) do
    new_page = socket.assigns.page + 1
    page_params = Controller.update_page_params(socket, %{page: new_page})

    {
      :noreply,
      socket
      |> push_patch(to: Routes.rush_index_path(socket, :index, page_params))
    }
  end

  def handle_event("sort_statistics", %{"sort" => sort, "sort_order" => sort_order}, socket) do
    page_params = Controller.update_page_params(socket, %{sort: sort, sort_order: sort_order, page: 1})

    {
      :noreply,
      socket
      |> push_patch(to: Routes.rush_index_path(socket, :index, page_params))
    }
  end
end
