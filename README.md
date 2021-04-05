# GeoTaskTracker

Geo-based tasks tracker.
This is a solution to a [task explained here](./TASK.md).

# Dev setup:

Setup DB with PostGIS:
```
sudo apt-get install postgresql-13-postgis-3
mix ecto.create

sudo -u postgres psql geo_task_tracker_dev
# In psql:
create extension if not exists plpgsql;
create extension postgis;

mix ecto.migrate
```

(Optional) install GUI application for viewing Geo data:
```
sudo apt install qgis
```


To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
