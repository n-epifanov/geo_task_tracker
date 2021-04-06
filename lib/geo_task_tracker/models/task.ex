defmodule GeoTaskTracker.Models.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Geo.PostGIS.Geometry
  alias GeoTaskTracker.Repo
  alias GeoTaskTracker.Models.Task
  import Geo.PostGIS
  import Ecto.Query

  schema "tasks" do
    # Geometry type suits better for geographically compact data.
    # http://postgis.net/workshops/postgis-intro/geography.html#why-not-use-geography
    field :delivery, Geometry
    field :pickup, Geometry
    field :status, Ecto.Enum, values: [:new, :assigned, :done]

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:status, :pickup, :delivery])
    |> validate_required([:status, :pickup, :delivery])
  end

  def create!(
        {pickup_lon, pickup_lat},
        {delivery_lon, delivery_lat}
      ) do
    pickup = %Geo.Point{coordinates: {pickup_lon, pickup_lat}}
    delivery = %Geo.Point{coordinates: {delivery_lon, delivery_lat}}

    Repo.insert!(%Task{
      delivery: delivery,
      pickup: pickup,
      status: :new
    })
  end

  def find_nearest(lon, lat) do
    driver_pos = %Geo.Point{coordinates: {lon, lat}}
    range = 1000

    query =
      from task in Task,
        where: task.status == :new and st_dwithin_in_meters(^driver_pos, task.pickup, ^range),
        select: %{
          id: task.id,
          lon: st_x(task.pickup),
          lat: st_y(task.pickup),
          distance: st_distance_in_meters(^driver_pos, task.pickup)
        },
        order_by: st_distance_in_meters(^driver_pos, task.pickup),
        limit: 5

    Repo.all(query)
  end

  def update!(id, changes) do
    Repo.get!(Task, id)
    |> Task.changeset(changes)
    |> Repo.update!()
  end
end
