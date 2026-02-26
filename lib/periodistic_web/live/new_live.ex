defmodule PeriodisticWeb.NewLive do
  use PeriodisticWeb, :live_view

  alias Periodistic.Data.Post

  @impl true
  def mount(_params, _session, socket) do
     default_locale = "es"

    Gettext.put_locale(PeriodisticWeb.Gettext, default_locale)

    {:ok,
     socket
     |> assign(:page_title, "New Post")
     |> assign(:post, %Post{})
     |> assign(:timezone, "UTC")
     |> assign(:locale, default_locale)
     |> assign(:gettext_locale, default_locale)
     |> assign(:loading, true)}
  end

  @impl true
  def handle_event(
        "set_client_prefs",
        %{"locale" => locale},
        socket
      ) do

    locale = normalize_locale(locale)
    local = normalize_local(locale)

    # IMPORTANTE: fijar locale en proceso
    Gettext.put_locale(PeriodisticWeb.Gettext, local)
    Cldr.put_locale(Periodistic.Cldr, locale)

    socket =
      socket
      |> assign(:locale, locale)
      |> assign(:gettext_locale, local)
      |> assign(:loading, false)

    {:noreply, socket}
  end

  defp normalize_locale(locale) do
    locale
    |> String.replace("_", "-")
    |> Cldr.validate_locale(Periodistic.Cldr)
    |> case do
      {:ok, valid} -> valid
      _ -> "es"
    end
  end

  defp normalize_local(locale) do
    locale =
      case locale do
        %Cldr.LanguageTag{} -> Cldr.LanguageTag.to_string(locale)
        %_{} -> to_string(locale)
        other -> other
      end

    locale
    |> String.replace("_", "-")
    |> String.downcase()
    |> String.split("-")
    |> hd()
  end
end
