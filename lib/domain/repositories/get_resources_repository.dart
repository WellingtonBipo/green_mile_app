import 'package:dartz/dartz.dart';
import 'package:green_mile_app/core/exceptions.dart';
import 'package:green_mile_app/domain/entities/resource.dart';

abstract class GetResourcesRepository {
  Future<Either<Failure, List<Resource>>> getResources(
      {required bool fromDevice, Function(int, int)? onReceiveProgress});
}
