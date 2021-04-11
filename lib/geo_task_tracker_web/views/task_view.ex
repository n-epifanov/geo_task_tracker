defmodule GeoTaskTrackerWeb.TaskView do
  use GeoTaskTrackerWeb, :view
  alias GeoTaskTrackerWeb.TaskView

  def render("ok.json", _assigns) do
    %{status: :ok}
  end

  def render("index.json", %{tasks: tasks}) do
    %{status: :ok, tasks: render_many(tasks, TaskView, "task.json")}
  end

  def render("task.json", %{task: task}) do
    %{id: task.id, lon: task.lon, lat: task.lat}
  end
end
