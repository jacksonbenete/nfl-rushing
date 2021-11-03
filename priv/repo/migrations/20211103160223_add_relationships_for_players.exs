defmodule Rush.Repo.Migrations.AddRelationshipsForPlayers do
  use Ecto.Migration

  def change do
    alter table(:player_statistics) do
      add :player_id, references(:players), null: false
    end
  end
end
