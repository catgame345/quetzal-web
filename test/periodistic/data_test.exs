defmodule Periodistic.DataTest do
  use Periodistic.DataCase

  alias Periodistic.Data

  describe "posts" do
    alias Periodistic.Data.Post

    import Periodistic.DataFixtures

    @invalid_attrs %{autor: nil, email: nil, texto: nil, imagenes: nil, enlaces: nil, riesgo: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Data.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Data.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{autor: "some autor", email: "some email", texto: "some texto", imagenes: "some imagenes", enlaces: "some enlaces", riesgo: true}

      assert {:ok, %Post{} = post} = Data.create_post(valid_attrs)
      assert post.autor == "some autor"
      assert post.email == "some email"
      assert post.texto == "some texto"
      assert post.imagenes == "some imagenes"
      assert post.enlaces == "some enlaces"
      assert post.riesgo == true
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{autor: "some updated autor", email: "some updated email", texto: "some updated texto", imagenes: "some updated imagenes", enlaces: "some updated enlaces", riesgo: false}

      assert {:ok, %Post{} = post} = Data.update_post(post, update_attrs)
      assert post.autor == "some updated autor"
      assert post.email == "some updated email"
      assert post.texto == "some updated texto"
      assert post.imagenes == "some updated imagenes"
      assert post.enlaces == "some updated enlaces"
      assert post.riesgo == false
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_post(post, @invalid_attrs)
      assert post == Data.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Data.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Data.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Data.change_post(post)
    end
  end
end
