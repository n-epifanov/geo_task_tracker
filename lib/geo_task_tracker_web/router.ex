defmodule GeoTaskTrackerWeb.Router do
  use GeoTaskTrackerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GeoTaskTrackerWeb do
    pipe_through :api
  end
end
