defmodule Periodistic.DataFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Periodistic.Data` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        autor: "some autor",
        email: "some email",
        enlaces: "some enlaces",
        imagenes: "some imagenes",
        riesgo: true,
        texto: "some texto"
      })
      |> Periodistic.Data.create_post()

    post
  end
end
