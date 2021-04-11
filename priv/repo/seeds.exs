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
  pickup: %Geo.Point{coordinates: {55, 56}},
  delivery: %Geo.Point{coordinates: {66, 67}},
  status: :new
})

Repo.insert!(%Task{
  pickup: %Geo.Point{coordinates: {55.001, 56}},
  delivery: %Geo.Point{coordinates: {66.001, 67}},
  status: :new
})

Repo.insert!(%Task{
  pickup: %Geo.Point{coordinates: {55.01, 56}},
  delivery: %Geo.Point{coordinates: {66.01, 67}},
  status: :new
})

Repo.insert!(%Task{
  pickup: %Geo.Point{coordinates: {55, 56}},
  delivery: %Geo.Point{coordinates: {66, 67}},
  status: :done
})
