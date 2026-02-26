defmodule PeriodisticWeb.PostLive.FormComponent do
  use PeriodisticWeb, :live_component

  alias Periodistic.Data

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-3xl font-bold text-center"><%= gettext("New post") %></h1>
      <br />
      <.simple_form
        for={@form}
        id="post-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label={gettext("Title")} />
        <.input field={@form[:autor]} type="text" label={gettext("Author")} />
        <.input field={@form[:email]} type="text" label={gettext("Post")} />
        <.input field={@form[:texto]} type="textarea" label={gettext("Text")} />
        <.input field={@form[:imagenes]} type="text" label={gettext("Images")} />
        <.input field={@form[:enlaces]} type="text" label={gettext("Links")} />
        <.input field={@form[:riesgo]} type="checkbox" label={gettext("Risk")} />
        <:actions>
          <.button phx-disable-with={gettext("Saving...")}><%= gettext("Save post") %></.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{post: post} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Data.change_post(post))
     end)}
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset = Data.change_post(socket.assigns.post, post_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    save_post(socket, socket.assigns.action, post_params)
  end

  defp save_post(socket, :edit, post_params) do
    case Data.update_post(socket.assigns.post, post_params) do
      {:ok, post} ->
        notify_parent({:saved, post})

        {:noreply,
         socket
         |> put_flash(:info, "Post updated successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_post(socket, :new, post_params) do
    case Data.create_post(post_params) do
      {:ok, post} ->
        notify_parent({:saved, post})

        {:noreply,
         socket
         |> put_flash(:info, "Post created successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
