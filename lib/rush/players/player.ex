defmodule Rush.Players.Player do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Rush.Statistics.PlayerStatistic

  schema "players" do
    field :name, :string
    field :team, :string
    field :position, :string
    field :attempts, :integer, virtual: true
    field :attempts_per_game, :float, virtual: true
    field :total_yards, :integer, virtual: true
    field :average_yards_per_attempt, :float, virtual: true
    field :yards_per_game, :float, virtual: true
    field :total_touchdowns, :integer, virtual: true
    field :longest_rush, :integer, virtual: true
    field :longest_rush_is_touchdown, :boolean, virtual: true
    field :total_first_downs, :integer, virtual: true
    field :first_downs_percentage, :float, virtual: true
    field :rush_20_plus, :integer, virtual: true
    field :rush_40_plus, :integer, virtual: true
    field :fumbles, :integer, virtual: true

    has_one :player_statistics, PlayerStatistic

    timestamps()
  end

  def changeset(player, attrs, _opts \\ []) do
    player
    |> cast(attrs, [:name, :team, :position])
    |> validate_required([:name, :team, :position])
  end
end
