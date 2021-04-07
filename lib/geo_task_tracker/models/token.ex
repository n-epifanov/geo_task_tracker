defmodule GeoTaskTracker.Models.Token do
  use Ecto.Schema
  import Ecto.Changeset
  alias GeoTaskTracker.Repo
  alias GeoTaskTracker.Models.Token

  schema "tokens" do
    field :role, :string
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token, :role])
    |> validate_required([:token, :role])
  end

  def find(token_string) do
    case Repo.get_by(Token, token: token_string) do
      nil -> {:error, :token_not_found}
      token_model -> {:ok, token_model}
    end
  end
end
