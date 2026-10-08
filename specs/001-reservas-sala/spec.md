# Especificación: Reservas de sala

**Creada**: 2026-10-01
**Estado**: Borrador

## Historias y escenarios

### Historia 1 — Reservar una sala

Como estudiante autenticado, quiero reservar una sala de estudio por un intervalo de tiempo
para tener dónde trabajar con mi grupo.

**Prioridad**: sin reservas, la aplicación no cumple su propósito.

**Prueba independiente**: se puede solicitar una reserva y comprobar si fue aceptada.

**Escenarios de aceptación**:

1. **Dado** que la sala A está libre, **Cuando** la reservo de 09:00 a 10:00,
   **Entonces** la reserva queda registrada a mi nombre.
2. **Dado** que elijo como inicio las 10:00 y como fin las 09:00,
   **Cuando** intento reservar, **Entonces** la reserva se rechaza con el mensaje
   "La hora de fin debe ser posterior a la de inicio".
3. **Dado** que la sala A ya está reservada de 09:00 a 10:00,
   **Cuando** solicito la sala A de 09:30 a 10:30, **Entonces** la solicitud se rechaza con el
   mensaje "La sala ya está reservada en ese horario".
4. **Dado** que la sala A ya está reservada de 09:00 a 10:00,
   **Cuando** solicito la sala A de 09:15 a 09:45, **Entonces** la solicitud se rechaza con el
   mensaje "La sala ya está reservada en ese horario".
5. **Dado** que la sala A ya está reservada de 09:00 a 10:00,
   **Cuando** solicito la sala A de 08:00 a 11:00, **Entonces** la solicitud se rechaza con el
   mensaje "La sala ya está reservada en ese horario".
6. **Dado** que la sala A ya está reservada de 09:00 a 10:00,
   **Cuando** solicito la sala A de 10:00 a 11:00, **Entonces** la solicitud se acepta.
7. **Dado** que la sala A está reservada de 09:00 a 10:00 y la sala B está libre,
   **Cuando** solicito la sala B de 09:00 a 10:00, **Entonces** la solicitud se acepta.

## Requisitos

### Requisitos funcionales

- **RF-001**: El estudiante puede elegir una sala y un horario de inicio y fin.
- **RF-002**: El sistema registra una solicitud válida cuando la sala está disponible.
- **RF-003**: El horario de fin debe ser posterior al horario de inicio.
- **RF-004**: Dos reservas de la misma sala no pueden compartir ningún instante de tiempo.
- **RF-005**: Una reserva que termina cuando otra empieza no se considera solapada.
- **RF-006**: La disponibilidad de una sala se evalúa de forma independiente de las demás salas.

### Entidades principales

- **Reserva**: sala, estudiante, inicio y fin.
- **Sala**: espacio que puede reservarse de forma independiente.

## Criterios de éxito

- **CE-001**: Un estudiante completa una solicitud de reserva en menos de 30 segundos.
