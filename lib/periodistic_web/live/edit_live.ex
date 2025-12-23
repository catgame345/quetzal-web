defmodule PeriodisticWeb.EditLive do
  use PeriodisticWeb, :live_view

  alias Periodistic.Data

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    post = Data.get_post!(id)

    {:ok,
     socket
     |> assign(:page_title, "Edit Post")
     |> assign(:post, post)}
  end
end
