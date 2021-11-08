import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:green_mile_app/core/exceptions.dart';

import 'package:green_mile_app/domain/entities/resource.dart';
import 'package:green_mile_app/domain/usecases/get_resources.dart';
import 'package:green_mile_app/domain/repositories/get_resources_repository.dart';
import 'package:mocktail/mocktail.dart';

class GetResourcesRepositoryMock extends Mock
    implements GetResourcesRepository {}

main() {
  final repository = GetResourcesRepositoryMock();
  final getResources = GetResources(repository);

  test('Deve retornar uma lista de Resource quando chamado do dispositivo ',
      () async {
    when(() => repository.getResources(
            fromDevice: any(named: 'fromDevice'),
            onReceiveProgress: any(named: 'onReceiveProgress')))
        .thenAnswer((_) async => const Right(<Resource>[]));

    final result = await getResources(fromDevice: true);

    expect(result, isA<Right<Failure, List<Resource>>>());
  });

  test('Deve retornar uma Failure quando chamado do dispositivo', () async {
    when(() => repository.getResources(
            fromDevice: any(named: 'fromDevice'),
            onReceiveProgress: any(named: 'onReceiveProgress')))
        .thenAnswer((_) async => Left(Failure('')));

    final result = await getResources(fromDevice: true);

    expect(result, isA<Left<Failure, List<Resource>>>());
  });

  test('Deve retornar uma lista de Resource quando chamado da internet',
      () async {
    when(() => repository.getResources(
            fromDevice: any(named: 'fromDevice'),
            onReceiveProgress: any(named: 'onReceiveProgress')))
        .thenAnswer((_) async => const Right(<Resource>[]));

    final result = await getResources(fromDevice: false);

    expect(result, isA<Right<Failure, List<Resource>>>());
  });

  test('Deve retornar uma Failure quando chamado da internet', () async {
    when(() => repository.getResources(
            fromDevice: any(named: 'fromDevice'),
            onReceiveProgress: any(named: 'onReceiveProgress')))
        .thenAnswer((_) async => Left(Failure('')));

    final result = await getResources(fromDevice: false);

    expect(result, isA<Left<Failure, List<Resource>>>());
  });
}
