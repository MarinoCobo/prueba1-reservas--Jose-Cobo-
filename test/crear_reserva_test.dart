import 'package:flutter_test/flutter_test.dart';
import 'package:reservas_sala/domain/crear_reserva.dart';
import 'package:reservas_sala/domain/reserva.dart';

import 'support/reservas_en_memoria.dart';

DateTime hora(int h, [int m = 0]) => DateTime(2026, 10, 14, h, m);

SolicitudReserva solicitud(
  int inicio,
  int fin, {
  int minutoInicio = 0,
  int minutoFin = 0,
  String salaId = 'Sala A',
  String usuarioId = 'u1',
}) => SolicitudReserva(
      salaId: salaId,
      usuarioId: usuarioId,
      inicio: hora(inicio, minutoInicio),
      fin: hora(fin, minutoFin),
    );

void main() {
  late ReservasEnMemoria repositorio;
  late CrearReserva crearReserva;

  setUp(() {
    repositorio = ReservasEnMemoria();
    crearReserva = CrearReserva(repositorio);
  });

  test('acepta una reserva válida y la guarda', () async {
    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u1',
      inicio: hora(9),
      fin: hora(10),
    ));

    expect(resultado.aceptada, isTrue);
    expect(repositorio.reservas, hasLength(1));
  });

  test('rechaza una reserva cuyo fin no es posterior al inicio', () async {
    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u1',
      inicio: hora(10),
      fin: hora(9),
    ));

    expect(resultado.aceptada, isFalse);
    expect(resultado.mensaje, 'La hora de fin debe ser posterior a la de inicio');
    expect(repositorio.reservas, isEmpty);
  });

  test('rechaza un solapamiento parcial con una reserva de la misma sala', () async {
    await crearReserva(solicitud(9, 10));

    final resultado = await crearReserva(
      solicitud(9, 10, minutoInicio: 30, minutoFin: 30, usuarioId: 'u2'),
    );

    expect(resultado.aceptada, isFalse);
    expect(resultado.mensaje, 'La sala ya está reservada en ese horario');
    expect(repositorio.reservas, hasLength(1));
  });

  test('rechaza una solicitud contenida en una reserva existente', () async {
    await crearReserva(solicitud(9, 10));

    final resultado = await crearReserva(
      solicitud(9, 9, minutoInicio: 15, minutoFin: 45, usuarioId: 'u2'),
    );

    expect(resultado.aceptada, isFalse);
    expect(resultado.mensaje, 'La sala ya está reservada en ese horario');
    expect(repositorio.reservas, hasLength(1));
  });

  test('rechaza una solicitud que contiene una reserva existente', () async {
    await crearReserva(solicitud(9, 10));

    final resultado = await crearReserva(solicitud(8, 11, usuarioId: 'u2'));

    expect(resultado.aceptada, isFalse);
    expect(resultado.mensaje, 'La sala ya está reservada en ese horario');
    expect(repositorio.reservas, hasLength(1));
  });

  test('acepta reservas contiguas de la misma sala', () async {
    await crearReserva(solicitud(9, 10));

    final resultado = await crearReserva(solicitud(10, 11, usuarioId: 'u2'));

    expect(resultado.aceptada, isTrue);
    expect(repositorio.reservas, hasLength(2));
  });

  test('acepta el mismo horario si corresponde a otra sala', () async {
    await crearReserva(solicitud(9, 10));

    final resultado = await crearReserva(solicitud(9, 10, salaId: 'Sala B'));

    expect(resultado.aceptada, isTrue);
    expect(repositorio.reservas, hasLength(2));
  });
}
