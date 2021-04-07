defmodule GeoTaskTrackerWeb.Router do
  use GeoTaskTrackerWeb, :router
  alias GeoTaskTrackerWeb.Plugs

  pipeline :api do
    plug :accepts, ["json"]
    plug Plugs.Auth
  end

  scope "/api/v1", GeoTaskTrackerWeb do
    pipe_through :api

    resources "/tasks", TaskController, only: [:index, :create, :update]
  end
end
