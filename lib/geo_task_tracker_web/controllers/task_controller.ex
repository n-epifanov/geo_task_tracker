defmodule GeoTaskTrackerWeb.TaskController do
  use GeoTaskTrackerWeb, :controller

  alias GeoTaskTracker.Tracker
  alias GeoTaskTracker.Models.Task

  action_fallback GeoTaskTrackerWeb.FallbackController

  def index(conn, _params) do
    tasks = Tracker.list_tasks()
    render(conn, "index.json", tasks: tasks)
  end

  def create(conn, params) do
    with %{"pickup" => pickup_unsafe, "delivery" => delivery_unsafe} <- params,
         {:ok, pickup} <- validate_geopoint(pickup_unsafe),
         {:ok, delivery} <- validate_geopoint(delivery_unsafe) do
      _ = Task.create!({pickup.lon, pickup.lat}, {delivery.lon, delivery.lat})
      render(conn, "ok.json")
    else
      {:error, changeset} ->
        conn
        |> put_view(GeoTaskTrackerWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tracker.get_task!(id)
    render(conn, "show.json", task: task)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tracker.get_task!(id)

    with {:ok, %Task{} = task} <- Tracker.update_task(task, task_params) do
      render(conn, "show.json", task: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tracker.get_task!(id)

    with {:ok, %Task{}} <- Tracker.delete_task(task) do
      send_resp(conn, :no_content, "")
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
end
