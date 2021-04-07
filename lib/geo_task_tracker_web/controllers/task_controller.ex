defmodule GeoTaskTrackerWeb.TaskController do
  use GeoTaskTrackerWeb, :controller

  alias GeoTaskTracker.Models.Task

  action_fallback GeoTaskTrackerWeb.FallbackController

  def index(conn, params_unsafe) do
    with {:ok, position} <- validate_geopoint(params_unsafe) do
      tasks = Task.find_nearest(position.lon, position.lat)
      render(conn, "index.json", tasks: tasks)
    else
      {:error, changeset} ->
        render_error(conn, changeset)
    end
  end

  def create(conn, params) do
    with %{"pickup" => pickup_unsafe, "delivery" => delivery_unsafe} <- params,
         :ok <- validate_access(conn, :manager),
         {:ok, pickup} <- validate_geopoint(pickup_unsafe),
         {:ok, delivery} <- validate_geopoint(delivery_unsafe) do
      _ = Task.create!({pickup.lon, pickup.lat}, {delivery.lon, delivery.lat})
      render(conn, "ok.json")
    else
      {:error, :unauthorized} ->
        render_unauthorized(conn)

      {:error, changeset} ->
        render_error(conn, changeset)
    end
  end

  def update(conn, %{"id" => id, "status" => status}) do
    with :ok <- validate_access(conn, :driver) do
      Task.update!(id, %{"status" => status})
      render(conn, "ok.json")
    else
      _ ->
        render_unauthorized(conn)
    end
  end

  defp validate_geopoint(params) do
    types = %{lon: :float, lat: :float}

    changeset =
      {%{}, types}
      |> Ecto.Changeset.cast(params, Map.keys(types))
      |> Ecto.Changeset.validate_number(:lon,
        greater_than_or_equal_to: -180,
        less_than_or_equal_to: 180
      )
      |> Ecto.Changeset.validate_number(:lat,
        greater_than_or_equal_to: -90,
        less_than_or_equal_to: 90
      )

    if changeset.valid? do
      {:ok, changeset.changes}
    else
      {:error, changeset}
    end
  end

  defp validate_access(conn, role) do
    if conn.assigns[:role] == role do
      :ok
    else
      {:error, :unauthorized}
    end
  end

  defp render_error(conn, %Ecto.Changeset{} = changeset) do
    conn
    |> put_view(GeoTaskTrackerWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  defp render_unauthorized(conn) do
    conn
    |> put_status(403)
    |> put_view(GeoTaskTrackerWeb.ErrorView)
    |> render("403.json")
  end
end
