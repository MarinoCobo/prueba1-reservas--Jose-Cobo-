## Escenarios que elegí y por qué

Elegí solapamientos parciales, solicitudes contenidas y solicitudes que contienen una reserva para cubrir distintas formas de intersección (`specs/001-reservas-sala/spec.md:24`, `specs/001-reservas-sala/spec.md:27`, `specs/001-reservas-sala/spec.md:30`). El límite compartido y la misma franja en otra sala fijan los casos que sí se aceptan (`specs/001-reservas-sala/spec.md:33`, `specs/001-reservas-sala/spec.md:35`).

## Riesgo más grave del repositorio

`lib/data/supabase_config.dart:4` contiene una clave con rol `service_role`, y `README.md:20` indica usar ese tipo de clave. Si la clave está activa, publicar el repositorio expone acceso privilegiado a los datos y deja sin efecto las protecciones esperadas de RLS (`supabase/migracion.sql:14`).

## ¿La regla protege la app real?

`lib/domain/crear_reserva.dart:16` consulta las reservas de la sala y `lib/domain/crear_reserva.dart:22` rechaza una intersección. Sin embargo, la pantalla inserta directamente en Supabase (`lib/presentation/reserva_page.dart:60`), y la base solo comprueba que el fin sea posterior al inicio (`supabase/migracion.sql:11`). Por eso, la regla cubre el caso de uso probado, pero no el flujo real ni garantiza exclusión ante solicitudes concurrentes.
