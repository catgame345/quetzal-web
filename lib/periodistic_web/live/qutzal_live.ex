defmodule PeriodisticWeb.QutzalLive do
  use PeriodisticWeb, :live_view

  alias Periodistic.Data

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Data.subscribe()

    posts = Data.list_posts()

    # Idioma por defecto
    default_locale = "es"

    Gettext.put_locale(PeriodisticWeb.Gettext, default_locale)

    {:ok,
     socket
     |> assign(:page_title, "News")
     |> assign(:posts, posts)
     |> assign(:timezone, "UTC")
     |> assign(:locale, default_locale)
     |> assign(:gettext_locale, default_locale) # <-- CLAVE
     |> assign(:loading, true)}
  end

  @impl true
  def handle_event(
        "set_client_prefs",
        %{"timezone" => tz, "locale" => locale},
        socket
      ) do

    tz = normalize_timezone(tz)
    locale = normalize_locale(locale)
    local = normalize_local(locale)

    # IMPORTANTE: fijar locale en proceso
    Gettext.put_locale(PeriodisticWeb.Gettext, local)
    Cldr.put_locale(Periodistic.Cldr, locale)

    socket =
      socket
      |> assign(:timezone, tz)
      |> assign(:locale, locale)
      |> assign(:gettext_locale, local)
      |> assign(:loading, false)

    {:noreply, socket}
  end


  @impl true
  def handle_info({:post_created, _}, socket), do: reload(socket)
  def handle_info({:post_updated, _}, socket), do: reload(socket)
  def handle_info({:post_deleted, _}, socket), do: reload(socket)

  defp reload(socket) do
    posts = Data.list_posts()
    {:noreply, assign(socket, :posts, posts)}
  end

  defp normalize_timezone(tz) do
    case DateTime.shift_zone(DateTime.utc_now(), tz) do
      {:ok, _} -> tz
      _ -> "UTC"
    end
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

  defp format_datetime(datetime, tz, locale) do
    with {:ok, local} <- DateTime.shift_zone(datetime, tz) do
      Cldr.DateTime.to_string!(
        local,
        Periodistic.Cldr,
        locale: locale,
        format: :long
      )
    else
      _ -> "—"
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
