defmodule Periodistic.Cldr do
  use Cldr,
    locales: ["es-MX", "en-GB", "fr-FR", "ru-UA", "ja-JA", "ko-KR", "de-DE"],          # Idiomas soportados
    providers: [                     # Qué cosas queremos usar
      Cldr.Number,
      Cldr.DateTime,
      Cldr.Calendar
    ]
end
