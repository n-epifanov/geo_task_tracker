defmodule GeoTaskTrackerWeb.Plugs.Auth do
  @moduledoc false

  alias GeoTaskTracker.Models.Token
  import Plug.Conn
  import Phoenix.Controller
  require Logger

  @roles [:driver, :manager]

  def init(opts), do: opts

  def call(conn, _opts) do
    with {:ok, token_string} <- get_token(conn),
         {:ok, token_model} <- Token.find(token_string) do
      assign(conn, :role, String.to_existing_atom(token_model.role))
    else
      error ->
        Logger.error("Auth error #{inspect(error)}")

        conn
        |> put_status(403)
        |> put_view(GeoTaskTrackerWeb.ErrorView)
        |> render("403.json")
        |> halt()
    end
  end

  defp get_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        {:ok, token}

      _ ->
        {:error, :token_missing}
    end
  end
end
