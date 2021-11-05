defmodule RushWeb.StatisticsFilterComponent do
  @moduledoc false
  use RushWeb, :live_component

  alias Ecto.Changeset

  @types %{filter: :string}

  def validate(params) do
    {%{}, @types}
    |> Changeset.cast(params, Map.keys(@types))
    |> Changeset.validate_required([:filter])
    |> Changeset.update_change(:filter, &String.trim/1)
    |> Changeset.validate_length(:filter, min: 3)
    |> Changeset.validate_format(:filter, ~r/[A-Za-z0-9\ ]/)
    |> Map.put(:action, :validate)
  end
end
