# GeoTaskTracker

Geo-based tasks tracker.
This is a solution to a [task explained here](./TASK.md).

Simplifications due to the nature of the job application:
- no API documentation;
- auth tokens are plain strings stored in DB;
- path to task assumed to be a straight line.
TODO:
- decent test coverage
- describe error in respond on request failure
- return valid response codes on error like 4xx etc
- setup prod environment and deploy

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
mix run priv/repo/seeds.exs
```

(Optional) install GUI application for viewing Geo data:
```
sudo apt install qgis
```

Driver:
list:
http localhost:4000/api/v1/tasks Authorization:"Bearer some_valid_driver_token" lat==45 lon==66
change status:
http PATCH localhost:4000/api/v1/tasks/9 Authorization:"Bearer some_valid_driver_token" status=done

Manager:
http post localhost:4000/api/v1/tasks Authorization:"Bearer some_valid_manager_token" pickup:='{"lat": 55, "lon": 66}' delivery:='{"lat": 55, "lon": 66}'

Tokens:
some_valid_driver_token
another_valid_driver_token
some_valid_manager_token
another_valid_manager_token

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
