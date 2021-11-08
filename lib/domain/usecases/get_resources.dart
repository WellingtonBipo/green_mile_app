import 'package:dartz/dartz.dart';
import 'package:green_mile_app/core/exceptions.dart';
import 'package:green_mile_app/domain/entities/resource.dart';
import 'package:green_mile_app/domain/repositories/get_resources_repository.dart';

class GetResources {
  final GetResourcesRepository _repository;

  GetResources(this._repository);

  Future<Either<Failure, List<Resource>>> call({
    required bool fromDevice,
    Function(int, int)? onReceiveProgress,
  }) async {
    var result = await _repository.getResources(
        fromDevice: fromDevice, onReceiveProgress: onReceiveProgress);
    return result;
  }
}
