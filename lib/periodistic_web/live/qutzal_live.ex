defmodule PeriodisticWeb.QutzalLive do
  use PeriodisticWeb, :live_view

  alias Periodistic.Data

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Data.subscribe()
    {:ok, assign(socket, page_title: "News", posts: Data.list_posts())}
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
end
