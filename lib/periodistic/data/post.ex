defmodule Periodistic.Data.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :autor, :string
    field :email, :string
    field :texto, :string
    field :imagenes, :string
    field :enlaces, :string
    field :riesgo, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:autor, :email, :texto, :imagenes, :enlaces, :riesgo])
    |> validate_required([:autor, :email, :texto, :enlaces, :riesgo])
  end
end
