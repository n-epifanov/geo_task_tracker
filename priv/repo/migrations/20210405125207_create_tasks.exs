defmodule GeoTaskTracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def up do
    create table(:tasks) do
      add :status, :string
      add :pickup, :geometry
      add :delivery, :geometry

      timestamps()
    end

    execute("CREATE INDEX tasks_pickup_idx ON tasks USING GIST (pickup);")
  end
end
