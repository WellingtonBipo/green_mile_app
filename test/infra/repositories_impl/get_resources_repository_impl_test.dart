import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_mile_app/domain/entities/resource.dart';
import 'package:mocktail/mocktail.dart';

import 'package:green_mile_app/core/exceptions.dart';
import 'package:green_mile_app/infra/datasources/get_resources_datasource.dart';
import 'package:green_mile_app/infra/datasources/get_resources_from_device.dart';
import 'package:green_mile_app/infra/models/resource_model.dart';
import 'package:green_mile_app/infra/repositories_impl/get_resources_repository_impl.dart';

class GetResourcesDatasourceMock extends Mock
    implements GetResourcesDatasource {}

class GetResourcesFromDeviceMock extends Mock
    implements GetResourcesFromDevice {}

void main() {
  final dataSource = GetResourcesDatasourceMock();
  final fromDevice = GetResourcesFromDeviceMock();
  final getRescRepo = GetResourcesRepositoryImpl(dataSource, fromDevice);

  test('Deve retornar uma lista de Resource quando vindo da internet',
      () async {
    when(() => fromDevice.getResources())
        .thenAnswer((_) async => <ResourceModel>[]);

    when(() => fromDevice.setResources(<ResourceModel>[]))
        .thenAnswer((_) async => true);

    when(() => dataSource.getResources(
            onReceiveProgress: any(named: 'onReceiveProgress')))
        .thenAnswer((_) async => <ResourceModel>[]);

    final result = await getRescRepo.getResources(fromDevice: false);

    expect(result, isA<Right<Failure, List<Resource>>>());
  });

  test('Deve retornar uma Failure quando vindo da internet', () async {
    when(() => dataSource.getResources(
            onReceiveProgress: any(named: 'onReceiveProgress')))
        .thenAnswer((_) async => throw Failure(''));

    when(() => fromDevice.getResources())
        .thenAnswer((_) async => throw Failure(''));

    final result = await getRescRepo.getResources(fromDevice: false);

    expect(result, isA<Left<Failure, List<Resource>>>());
  });

  test('Deve retornar uma lista de Resource quando vindo do dispositivo',
      () async {
    when(() => dataSource.getResources(
            onReceiveProgress: any(named: 'onReceiveProgress')))
        .thenAnswer((_) async => <ResourceModel>[]);

    when(() => fromDevice.getResources())
        .thenAnswer((_) async => <ResourceModel>[]);

    final result = await getRescRepo.getResources(fromDevice: true);

    expect(result, isA<Right<Failure, List<Resource>>>());
  });

  test('Deve retornar uma Failure quando vindo do dispositivo', () async {
    when(() => dataSource.getResources(
            onReceiveProgress: any(named: 'onReceiveProgress')))
        .thenAnswer((_) async => throw Failure(''));

    when(() => fromDevice.getResources())
        .thenAnswer((_) async => throw Failure(''));

    final result = await getRescRepo.getResources(fromDevice: true);

    expect(result, isA<Left<Failure, List<Resource>>>());
  });
}
