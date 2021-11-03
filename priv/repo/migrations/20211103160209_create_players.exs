defmodule Rush.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string, null: false
      add :team, :string, null: false
      add :position, :string, null: false

      timestamps()
    end

#    create unique_index(:players, [:name])
  end
end
