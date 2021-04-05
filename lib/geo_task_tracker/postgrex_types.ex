defmodule GeoTaskTracker.PostgrexTypes do
  @moduledoc false

  Postgrex.Types.define(
    GeoTaskTracker.PostgresTypes,
    [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
    json: Jason
  )
end
