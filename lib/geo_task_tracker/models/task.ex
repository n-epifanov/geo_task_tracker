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
end
