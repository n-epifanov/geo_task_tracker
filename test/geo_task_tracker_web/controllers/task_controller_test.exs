defmodule GeoTaskTrackerWeb.TaskControllerTest do
  use GeoTaskTrackerWeb.ConnCase

  alias GeoTaskTracker.Models.Task
  alias GeoTaskTracker.Models.Token
  alias GeoTaskTracker.Repo

  setup %{conn: conn} do
    Task.create!({44, 45}, {55, 56})
    Task.create!({44, 45.001}, {55, 56})
    Task.create!({44, 46}, {55, 56})

    Repo.insert!(%Task{
      delivery: %Geo.Point{coordinates: {44, 45}},
      pickup: %Geo.Point{coordinates: {55, 56}},
      status: :done
    })

    Repo.insert!(%Token{token: "driver_token", role: "driver"})
    Repo.insert!(%Token{token: "manager_token", role: "manager"})

    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists nearest tasks", %{conn: conn} do
      conn = put_req_header(conn, "authorization", "Bearer driver_token")
      conn = get(conn, Routes.task_path(conn, :index), lon: 44, lat: 45)

      assert %{
               "status" => "ok",
               "tasks" => [
                 %{"id" => _, "lat" => 45.0, "lon" => 44.0},
                 %{"id" => _, "lat" => 45.001, "lon" => 44.0}
               ]
             } = json_response(conn, 200)
    end
  end

  @create_params [pickup: %{lat: 55, lon: 66}, delivery: %{lat: 77, lon: 88}]

  describe "create task" do
    test "creates task when data is valid", %{conn: conn} do
      conn = put_req_header(conn, "authorization", "Bearer manager_token")
      conn = post(conn, Routes.task_path(conn, :create), @create_params)
      assert json_response(conn, 200) == %{"status" => "ok"}
    end

    test "with driver token returns 403", %{conn: conn} do
      conn = put_req_header(conn, "authorization", "Bearer driver_token")
      conn = post(conn, Routes.task_path(conn, :create), @create_params)
      assert json_response(conn, 403) == %{"status" => "error", "error_reason" => "forbidden"}
    end

    test "with no token returns 403", %{conn: conn} do
      conn = post(conn, Routes.task_path(conn, :create), @create_params)
      assert json_response(conn, 403) == %{"status" => "error", "error_reason" => "forbidden"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = put_req_header(conn, "authorization", "Bearer manager_token")

      conn =
        post(conn, Routes.task_path(conn, :create),
          pickup: %{lat: "A", lon: 66},
          delivery: %{lat: 77, lon: 88}
        )

      assert json_response(conn, 200) == %{
               "error_reason" => %{"lat" => ["is invalid"]},
               "status" => "error"
             }
    end
  end
end
