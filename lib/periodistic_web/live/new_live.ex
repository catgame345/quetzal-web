defmodule PeriodisticWeb.NewLive do
  use PeriodisticWeb, :live_view

  alias Periodistic.Data.Post

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "New Post")
     |> assign(:post, %Post{})}
  end
end
