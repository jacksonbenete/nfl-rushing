defmodule Rush.Repo.Migrations.CreatePlayerStatistics do
  use Ecto.Migration

  def change do
    create table(:player_statistics) do
      add :attempts, :int, null: false
      add :attempts_per_game, :float, null: false
      add :total_yards, :int, null: false
      add :average_yards_per_attempt, :float, null: false
      add :yards_per_game, :float, null: false
      add :total_touchdowns, :int, null: false
      add :longest_rush, :int, null: false
      add :longest_rush_is_touchdown, :boolean, null: false
      add :total_first_downs, :int, null: false
      add :first_downs_percentage, :float, null: false
      add :rush_20_plus, :int, null: false
      add :rush_40_plus, :int, null: false
      add :fumbles, :int, null: false

      timestamps()
    end
  end
end
