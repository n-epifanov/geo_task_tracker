defmodule GeoTaskTracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :status, :string
      add :pickup, :geometry
      add :delivery, :geometry

      timestamps()
    end
  end
end
