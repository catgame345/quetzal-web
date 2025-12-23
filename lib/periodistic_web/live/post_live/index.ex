defmodule PeriodisticWeb.PostLive.Index do
  use PeriodisticWeb, :live_view

  alias Periodistic.Data

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Data.subscribe()
    {:ok, stream(socket, :posts, Data.list_posts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_info({PeriodisticWeb.PostLive.FormComponent, {:saved, post}}, socket) do
    {:noreply, stream_insert(socket, :posts, post)}
  end

  @impl true
  def handle_info({:post_created, _post}, socket) do
    {:noreply, assign(socket, :posts, Data.list_posts())}
  end

  @impl true
  def handle_info({:post_updated, _post}, socket) do
    {:noreply, assign(socket, :posts, Data.list_posts())}
  end

  @impl true
  def handle_info({:post_deleted, _post}, socket) do
    {:noreply, assign(socket, :posts, Data.list_posts())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Data.get_post!(id)
    {:ok, _} = Data.delete_post(post)

    {:noreply, stream_delete(socket, :posts, post)}
  end
end
