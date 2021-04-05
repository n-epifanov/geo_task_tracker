defmodule GeoTaskTrackerWeb.Router do
  use GeoTaskTrackerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", GeoTaskTrackerWeb do
    pipe_through :api

    resources "/tasks", TaskController, except: [:new, :edit]
  end
end
