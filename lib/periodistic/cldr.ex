defmodule Periodistic.Cldr do
  use Cldr,
    default_locale: "es",           # Español por defecto
    locales: ["es", "en"],          # Idiomas soportados
    providers: [                     # Qué cosas queremos usar
      Cldr.Number,
      Cldr.DateTime,
      Cldr.Calendar
    ],
    calendars: [
      gregorian: Cldr.Calendar.Gregorian
    ]
end
