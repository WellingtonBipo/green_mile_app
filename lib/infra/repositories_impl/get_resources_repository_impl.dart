import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:green_mile_app/domain/entities/resource.dart';
import 'package:green_mile_app/core/exceptions.dart';
import 'package:green_mile_app/domain/repositories/get_resources_repository.dart';
import 'package:green_mile_app/infra/datasources/get_resources_datasource.dart';
import 'package:green_mile_app/infra/datasources/get_resources_from_device.dart';

class GetResourcesRepositoryImpl extends GetResourcesRepository {
  final GetResourcesDatasource _datasource;
  final GetResourcesFromDevice _fromDevice;

  GetResourcesRepositoryImpl(this._datasource, this._fromDevice);

  @override
  Future<Either<Failure, List<Resource>>> getResources(
      {required bool fromDevice, Function(int, int)? onReceiveProgress}) async {
    try {
      if (fromDevice) {
        return right(await _fromDevice.getResources());
      } else {
        final resources = await _datasource.getResources(
            onReceiveProgress: onReceiveProgress);
        await _fromDevice.setResources(resources);
        return right(resources);
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        return left(HttpBadRequest(
            e.response!.data.toString(), e.response!.statusCode!));
      } else if (e.type == DioErrorType.receiveTimeout) {
        return left(HttpFailure('Não há mais resposta da conexão'));
      } else {
        if (e.toString().toLowerCase().contains('socketexception')) {
          return left(HttpFailure('Não há conexão com a internet'));
        }
        return left(HttpFailure('Erro: ' + e.toString()));
      }
    } catch (e, stackTrace) {
      debugPrint('Error: $e\nStacktrace: $stackTrace');
      return left(Failure('Erro: ' + e.toString()));
    }
  }
}
