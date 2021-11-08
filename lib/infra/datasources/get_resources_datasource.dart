import 'package:green_mile_app/infra/models/resource_model.dart';

abstract class GetResourcesDatasource {
  Future<List<ResourceModel>> getResources(
      {Function(int, int)? onReceiveProgress});
}
