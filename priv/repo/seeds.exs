# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     GeoTaskTracker.Repo.insert!(%GeoTaskTracker.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias GeoTaskTracker.Repo
alias GeoTaskTracker.Models.Task
alias GeoTaskTracker.Models.Token

Repo.insert!(%Token{token: "some_valid_driver_token", role: "driver"})
Repo.insert!(%Token{token: "another_valid_driver_token", role: "driver"})
Repo.insert!(%Token{token: "some_valid_manager_token", role: "manager"})
Repo.insert!(%Token{token: "another_valid_manager_token", role: "manager"})

Repo.insert!(%Task{
  delivery: %Geo.Point{coordinates: {44, 45}},
  pickup: %Geo.Point{coordinates: {55, 56}},
  status: :new
})
Repo.insert!(%Task{
  delivery: %Geo.Point{coordinates: {44.001, 45}},
  pickup: %Geo.Point{coordinates: {55, 56}},
  status: :new
})
Repo.insert!(%Task{
  delivery: %Geo.Point{coordinates: {44, 45}},
  pickup: %Geo.Point{coordinates: {55, 56}},
  status: :done
})
